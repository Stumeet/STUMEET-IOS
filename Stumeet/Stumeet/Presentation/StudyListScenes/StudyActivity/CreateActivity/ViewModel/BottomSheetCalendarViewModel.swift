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
        let didTapAmButtonTapPublisher: AnyPublisher<Void, Never>
        let didTapPmButtonTapPublisher: AnyPublisher<Void, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
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
        let isEnableBackMonthButton: AnyPublisher<Bool, Never>
        let isSelectedAmButton: AnyPublisher<Bool, Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completeDate: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: BottomSheetCalendarUseCase
    private let cal: Calendar = Calendar.current
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Subject
    
    let dragEventSubject = PassthroughSubject<DragInfo, Never>()
    private let calendarDateItemSubject = CurrentValueSubject<[CalendarDate], Never>([])
    private let selectedDateSubject = CurrentValueSubject<Date?, Never>(Date())
    private lazy var componentsSubject = CurrentValueSubject<DateComponents, Never>(makeComponents())
    private let isAmSubject = CurrentValueSubject<Bool, Never>(true)
    private let isSelectedHoursSubject = CurrentValueSubject<[Bool], Never>(Array(repeating: false, count: 12))
    private let isSelectedMinuteSubject = CurrentValueSubject<[Bool], Never>(Array(repeating: false, count: 12))
    
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
            .map { +1 }
            .map(updateComponentMonth)
            .flatMap(useCase.setCalendarItem)
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        input.didTapBackMonthButton
            .map { -1 }
            .map(updateComponentMonth)
            .flatMap(useCase.setCalendarItem)
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        input.didSelectedCalendarCell
            .map { indexPath in
                return (indexPath, self.calendarDateItemSubject.value, self.componentsSubject.value, self.cal)
            }
            .flatMap(useCase.setSelectedCalendarCell)
            .sink(receiveValue: { [weak self] data in
                self?.selectedDateSubject.send(data.selectedDate)
                self?.calendarDateItemSubject.send(data.data)
            })
            .store(in: &cancellable)
        
        let calendarSectionItems = calendarDateItemSubject
            .map(setSectionItems)
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
        
        let isEnableBackMonthButton = componentsSubject
            .map { ($0, self.cal) }
            .flatMap(useCase.setIsEnableBackMonthButton)
            .eraseToAnyPublisher()
        
        let isSelectedAmButton = Publishers.Merge(
            input.didTapAmButtonTapPublisher.map { _ in true },
            input.didTapPmButtonTapPublisher.map { _ in false }
        )
            .handleEvents(receiveOutput: isAmSubject.send)
        .eraseToAnyPublisher()

        
        let isEnableCompleteButton = Publishers.CombineLatest3(selectedDateSubject, isSelectedHoursSubject, isSelectedMinuteSubject)
            .flatMap(useCase.setIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let completeDate = input.didTapCompleteButton
            .map { _ in
                (self.selectedDateSubject.value!, self.isAmSubject.value, self.isSelectedHoursSubject.value, self.isSelectedMinuteSubject.value)
            }
            .flatMap(useCase.setCompletedDateText)
            .eraseToAnyPublisher()
        
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
            isSelectedMinute: isSelectedMinutes,
            isEnableBackMonthButton: isEnableBackMonthButton,
            isSelectedAmButton: isSelectedAmButton,
            isEnableCompleteButton: isEnableCompleteButton,
            completeDate: completeDate
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
    
    func updateComponentMonth(increment: Int) -> (Calendar, DateComponents, Date?) {
        var components = componentsSubject.value
        components.month! += increment
        let selectedDate = selectedDateSubject.value
        componentsSubject.send(components)
        return (cal, components, selectedDate)
    }
    
    func setSectionItems(dateItems: [CalendarDate]) -> [CalendarSectionItem] {
        var sectionItems: [CalendarSectionItem] = []
        sectionItems.append(contentsOf: dateItems.map { .dayCell($0) })
        sectionItems.append(contentsOf: CalendarWeek.weeks.map { .weekCell($0) })
        return sectionItems
    }
}
