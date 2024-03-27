//
//  BottomSheetCalendarViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import Combine
import Foundation

final class BottomSheetCalendarViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapBackgroundButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    
    // MARK: - Init
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        let dismiss = input.didTapBackgroundButton
        
        return Output(
            dismiss: dismiss
        )
    }
}
