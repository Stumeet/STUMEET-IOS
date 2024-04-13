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
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: AnyPublisher<Void, Never>
        let adjustHeight: AnyPublisher<CGFloat, Never>
        let isRestoreBottomSheetView: AnyPublisher<Bool, Never>
        let showCalendar: AnyPublisher<Void, Never>
        let showDate: AnyPublisher<Void, Never>
        let calendarItem: AnyPublisher<CalendarDay, Never>
    }
    
    // MARK: - Properties
    
    let dragEventSubject = PassthroughSubject<DragInfo, Never>()
    let useCase: BottomSheetCalendarUseCase
    let calendarItem: AnyPublisher<CalendarDay, Never>
    
    
    // MARK: - Init
    
    init(useCase: BottomSheetCalendarUseCase) {
        self.useCase = useCase
        calendarItem = useCase.setCalendarItem()
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
        
        return Output(
            dismiss: dismiss,
            adjustHeight: adjustHeight,
            isRestoreBottomSheetView: isRestoreBottomSheetView,
            showCalendar: showCalendar,
            showDate: showDate,
            calendarItem: calendarItem
        )
    }
}
