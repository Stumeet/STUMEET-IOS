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
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: AnyPublisher<Void, Never>
        let adjustHeight: AnyPublisher<CGFloat, Never>
        let isRestoreBottomSheetView: AnyPublisher<Bool, Never>
        let showCalendar: AnyPublisher<Void, Never>
        let showDate: AnyPublisher<Void, Never>
        let calendarItem: AnyPublisher<CalendarDay, Never>
        let selectedDay: AnyPublisher<AttributedString?, Never>
    }
    
    // MARK: - Properties
    
    let dragEventSubject = PassthroughSubject<DragInfo, Never>()
    let useCase: BottomSheetCalendarUseCase
    let cal: Calendar = Calendar.current
    lazy var monthDateFormatter: DateFormatter = makeMonthDateFormmater()
    lazy var dayDateFormatter: DateFormatter = makeDayDateFormatter()
    lazy var components: DateComponents = makeComponents()
    let calendarItemSubject = CurrentValueSubject<CalendarDay?, Never>(nil)
    let selectedDay = CurrentValueSubject<AttributedString?, Never>(nil)
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: BottomSheetCalendarUseCase) {
        self.useCase = useCase
        
        useCase.setCalendarItem(cal: cal, dateFormatter: monthDateFormatter, components: components)
            .sink(receiveValue: calendarItemSubject.send)
            .store(in: &cancellable)
        
        useCase.setSelectedDay(dateFormatter: dayDateFormatter)
            .sink(receiveValue: selectedDay.send)
            .store(in: &cancellable)
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let dismiss = input.didTapBackgroundButton
        
        let adjustHeight = dragEventSubject
            .filter { $0.state == .changed }
            .map { ($0.bottomSheetViewHeight, $0.translationY)}
            .flatMap(useCase.setAdjustHeight)
            .eraseToAnyPublisher()
        
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
            .compactMap { [weak self] _ -> DateComponents? in
                guard let self = self else { return nil }
                var components = self.components
                components.month! += 1
                self.components = components
                return components
            }
            .flatMap { [weak self] components -> AnyPublisher<CalendarDay, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.useCase.setCalendarItem(cal: self.cal, dateFormatter: self.monthDateFormatter, components: components)
            }
            .sink(receiveValue: calendarItemSubject.send)
            .store(in: &cancellable)
        
        input.didTapBackMonthButton
            .compactMap { [weak self] _ -> DateComponents? in
                guard let self = self else { return nil }
                var components = self.components
                components.month! -= 1
                self.components = components
                return components
            }
            .flatMap { [weak self] components -> AnyPublisher<CalendarDay, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.useCase.setCalendarItem(cal: self.cal, dateFormatter: self.monthDateFormatter, components: components)
            }
            .sink(receiveValue: calendarItemSubject.send)
            .store(in: &cancellable)
        
        
        let calendarItem = calendarItemSubject.compactMap { $0 }.eraseToAnyPublisher()
        
        return Output(
            dismiss: dismiss,
            adjustHeight: adjustHeight,
            isRestoreBottomSheetView: isRestoreBottomSheetView,
            showCalendar: showCalendar,
            showDate: showDate,
            calendarItem: calendarItem,
            selectedDay: selectedDay.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Function
    
    func makeMonthDateFormmater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }
    
    func makeDayDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. M. d EEE"
        return dateFormatter
    }

    func makeComponents() -> DateComponents {
        var component = DateComponents()
        let now = Date()
        component.year = cal.component(.year, from: now)
        component.month = cal.component(.month, from: now)
        component.day = 1
        
        return component
    }
}
