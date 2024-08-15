//
//  SelectStudyTimeViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import Combine
import Foundation

final class SelectStudyTimeViewModel: ViewModelType {
    
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
        let didDragEvent: AnyPublisher<DragInfo, Never>
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
        let isSelectedHours: AnyPublisher<[Bool], Never>
        let isSelectedMinute: AnyPublisher<[Bool], Never>
        let isSelectedAmButton: AnyPublisher<Bool, Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completedTime: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: SelectStudyTimeUseCase
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Init
    
    init(useCase: SelectStudyTimeUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let isAmSubject = CurrentValueSubject<Bool, Never>(true)
        let isSelectedHoursSubject = CurrentValueSubject<[Bool], Never>([])
        let isSelectedMinuteSubject = CurrentValueSubject<[Bool], Never>([])
        
        
        let isSelectedHours = isSelectedHoursSubject.eraseToAnyPublisher()
        let isSelectedMinutes = isSelectedMinuteSubject.eraseToAnyPublisher()
        let isSelectedAmButton = isAmSubject.eraseToAnyPublisher()
        
        let dismiss = input.didTapBackgroundButton
        
        let adjustHeight = input.didDragEvent
            .filter { $0.state == .changed }
            .map { ($0.bottomSheetViewHeight, $0.translationY)}
            .flatMap(useCase.setAdjustHeight)
            .eraseToAnyPublisher()
        
        let isRestoreBottomSheetView = input.didDragEvent
            .filter { $0.state == .ended || $0.state == .cancelled }
            .map { ($0.velocityY, $0.bottomSheetViewHeight)}
            .flatMap(useCase.setIsRestoreBottomSheetView)
            .eraseToAnyPublisher()
        
        useCase.initHourSelecteds()
            .sink(receiveValue: isSelectedHoursSubject.send)
            .store(in: &cancellables)
        
        useCase.initMinuteSelecteds()
            .sink(receiveValue: isSelectedMinuteSubject.send)
            .store(in: &cancellables)
        
        input.didTapHourButton
            .map { ($0, isSelectedHoursSubject.value) }
            .flatMap(useCase.getSelectedTimeButton)
            .sink(receiveValue: isSelectedHoursSubject.send)
            .store(in: &cancellables)
        
        input.didTapMinuteButton
            .map { ($0, isSelectedMinuteSubject.value) }
            .flatMap(useCase.getSelectedTimeButton)
            .sink(receiveValue: isSelectedMinuteSubject.send)
            .store(in: &cancellables)
        
        Publishers.Merge(
            input.didTapAmButtonTapPublisher.map { _ in true },
            input.didTapPmButtonTapPublisher.map { _ in false })
        .sink(receiveValue: isAmSubject.send)
        .store(in: &cancellables)
        
        
        let isEnableCompleteButton = Publishers.CombineLatest( isSelectedHoursSubject, isSelectedMinuteSubject)
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let completedTime = input.didTapCompleteButton
            .map { _ in
                (
                    isAmSubject.value,
                    isSelectedHoursSubject.value,
                    isSelectedMinuteSubject.value
                )
            }
            .flatMap(useCase.getCompletedTimeText)
            .eraseToAnyPublisher()
        
        
        return Output(
            dismiss: dismiss,
            adjustHeight: adjustHeight,
            isRestoreBottomSheetView: isRestoreBottomSheetView,
            isSelectedHours: isSelectedHours,
            isSelectedMinute: isSelectedMinutes,
            isSelectedAmButton: isSelectedAmButton,
            isEnableCompleteButton: isEnableCompleteButton,
            completedTime: completedTime
        )
    }
}
