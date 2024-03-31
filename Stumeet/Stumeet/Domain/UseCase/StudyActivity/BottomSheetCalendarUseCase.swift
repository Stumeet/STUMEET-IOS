//
//  BottomSheetCalendarUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/31/24.
//

import Combine
import Foundation

protocol BottomSheetCalendarUseCase {
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never>
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never>
}

final class DefualtBottomSheetCalendarUseCase: BottomSheetCalendarUseCase {
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never> {
        return Just(max(0, min(536, bottomSheetHeight - translationY)))
            .eraseToAnyPublisher()
    }
    
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never> {
        return Just((velocityY > 1500 || bottomSheetHeight < 268)).eraseToAnyPublisher()
    }
    
    
}
