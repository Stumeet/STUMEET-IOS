//
//  BottomSheetCalendarViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import Combine
import Foundation

final class BottomSheetCalendarViewModel: ViewModelType {

    enum DragState {
        case began
        case changed
        case ended
        case cancelled
    }
    
    struct DragInfo {
        let state: DragState
        let translationY: CGFloat
        let velocityY: CGFloat
        let bottomSheetViewHeight: CGFloat
    }
    
    // MARK: - Input
    
    struct Input {
        let didTapBackgroundButton: AnyPublisher<Void, Never>
        let didTapCalendarButton: AnyPublisher<Void, Never>
        let didTapDateButton: AnyPublisher<Void, Never>
        let didTapNextMonthButton: AnyPublisher<Void, Never>
        let didTapBackMonthButton: AnyPublisher<Void, Never>
        let didSelectedCalendarCell: AnyPublisher<IndexPath, Never>
        let didTapHourButton: AnyPublisher<Int, Never>
        let didTapMinuteButton: AnyPublisher<Int, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: AnyPublisher<Void, Never>
        let adjustHeight: AnyPublisher<CGFloat, Never>
        let isRestoreBottomSheetView: AnyPublisher<Bool, Never>
        let showCalendar: AnyPublisher<Void, Never>
        let showDate: AnyPublisher<Void, Never>
        let calendarSectionItems: AnyPublisher<[CalendarSectionItem], Never>
        let selectedDate: AnyPublisher<AttributedString?, Never>
        let yearMonthTitle: AnyPublisher<String, Never>
        let isSelectedHours: AnyPublisher<[Bool], Never>
        let isSelectedMinute: AnyPublisher<[Bool], Never>
    }
    
    // MARK: - Properties
    
    let useCase: BottomSheetCalendarUseCase
    let cal: Calendar = Calendar.current
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Subject
    
    let dragEventSubject = PassthroughSubject<DragInfo, Never>()
    let calendarDateItemSubject = CurrentValueSubject<[CalendarDate], Never>([])
    let selectedDateSubject = CurrentValueSubject<Date?, Never>(Date())
    lazy var componentsSubject = CurrentValueSubject<DateComponents, Never>(makeComponents())
    let isSelectedHoursSubject = CurrentValueSubject<[Bool], Never>(Array(repeating: false, count: 12))
    let isSelectedMinuteSubject = CurrentValueSubject<[Bool], Never>(Array(repeating: false, count: 12))
    
    // MARK: - Init
    
    init(useCase: BottomSheetCalendarUseCase) {
        self.useCase = useCase
        
        useCase.setCalendarItem(cal: cal, components: componentsSubject.value, selectedDate: nil)
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let dismiss = input.didTapBackgroundButton
        
        // bottomSheetView 높이 조정
        let adjustHeight = dragEventSubject
            .filter { $0.state == .changed }
            .map { ($0.bottomSheetViewHeight, $0.translationY)}
            .flatMap(useCase.setAdjustHeight)
            .eraseToAnyPublisher()
        
        // bottomSheetView 높이 되돌리기
        let isRestoreBottomSheetView = dragEventSubject
            .filter { $0.state == .ended || $0.state == .cancelled }
            .map { ($0.velocityY, $0.bottomSheetViewHeight)}
            .flatMap(useCase.setIsRestoreBottomSheetView)
            .eraseToAnyPublisher()
        
        let showCalendar = input.didTapCalendarButton
            .eraseToAnyPublisher()
        
        let showDate = input.didTapDateButton
            .eraseToAnyPublisher()
        
        input.didTapNextMonthButton
            .compactMap { [weak self] _ -> (DateComponents?, Date?) in
                var components = self?.componentsSubject.value
                components?.month! += 1
                let selectedDate = self?.selectedDateSubject.value
                return (components, selectedDate)
            }
            .flatMap { [weak self] components, selectedDate -> AnyPublisher<CalendarData, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                self.componentsSubject.send(components!)
                return self.useCase.setCalendarItem(cal: self.cal, components: components!, selectedDate: selectedDate)
            }
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        input.didTapBackMonthButton
            .compactMap { [weak self] _ -> (DateComponents?, Date?) in
                var components = self?.componentsSubject.value
                components?.month! -= 1
                let selectedDate = self?.selectedDateSubject.value
                return (components, selectedDate)
            }
            .flatMap { [weak self] components, selectedDate -> AnyPublisher<CalendarData, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                self.componentsSubject.send(components!)
                return self.useCase.setCalendarItem(cal: self.cal, components: components!, selectedDate: selectedDate)
            }
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        input.didSelectedCalendarCell
            .map {
                return ($0, self.calendarDateItemSubject.value, self.componentsSubject.value, self.cal)
            }
            .flatMap(useCase.setSelectedCalendarCell)
            .sink(receiveValue: { [weak self] data in
                self?.selectedDateSubject.send(data.selectedDate)
                self?.calendarDateItemSubject.send(data.data)
            })
            .store(in: &cancellable)
        
        let calendarSectionItems = calendarDateItemSubject
            .map { dateItem in
                var items: [CalendarSectionItem] = []
                items.append(contentsOf: dateItem.map { .dayCell($0) })
                items.append(contentsOf: CalendarWeek.weeks.map { .weekCell($0) })
                return items
            }
            .eraseToAnyPublisher()
        
        let yearMonthTitle = componentsSubject
            .map { (self.cal, $0) }
            .flatMap(useCase.setYearMonthTitle)
            .eraseToAnyPublisher()
        
        let selectedDateText =
        selectedDateSubject
            .compactMap { $0 }
            .flatMap(useCase.setSelectedDateText)
            .eraseToAnyPublisher()
        
        input.didTapHourButton
            .map { ($0, self.isSelectedHoursSubject.value) }
            .flatMap(useCase.setSelectedTimeButton)
            .sink(receiveValue: isSelectedHoursSubject.send)
            .store(in: &cancellable)
        
        let isSelectedHours = isSelectedHoursSubject.eraseToAnyPublisher()
        
        input.didTapMinuteButton
            .map { ($0, self.isSelectedMinuteSubject.value) }
            .flatMap(useCase.setSelectedTimeButton)
            .sink(receiveValue: isSelectedMinuteSubject.send)
            .store(in: &cancellable)
        
        let isSelectedMinutes = isSelectedMinuteSubject.eraseToAnyPublisher()
        
        return Output(
            dismiss: dismiss,
            adjustHeight: adjustHeight,
            isRestoreBottomSheetView: isRestoreBottomSheetView,
            showCalendar: showCalendar,
            showDate: showDate,
            calendarSectionItems: calendarSectionItems,
            selectedDate: selectedDateText,
            yearMonthTitle: yearMonthTitle,
            isSelectedHours: isSelectedHours,
            isSelectedMinute: isSelectedMinutes
        )
    }
    
    // MARK: - Function

    func makeComponents() -> DateComponents {
        var component = DateComponents()
        let now = Date()
        component.year = cal.component(.year, from: now)
        component.month = cal.component(.month, from: now)
        component.day = 1
        
        return component
    }
}
