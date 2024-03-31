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
        
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: AnyPublisher<Void, Never>
        let adjustHeight: AnyPublisher<CGFloat, Never>
        let isRestoreBottomSheetView: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    let dragEventSubject = PassthroughSubject<DragInfo, Never>()
    let useCase: BottomSheetCalendarUseCase
    
    // MARK: - Init
    
    init(useCase: BottomSheetCalendarUseCase) {
        self.useCase = useCase
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
        
        return Output(
            dismiss: dismiss,
            adjustHeight: adjustHeight,
            isRestoreBottomSheetView: isRestoreBottomSheetView
        )
    }
}
