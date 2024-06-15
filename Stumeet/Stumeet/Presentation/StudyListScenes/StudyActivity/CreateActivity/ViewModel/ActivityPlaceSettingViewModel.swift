//
//  ActivityPlaceSettingViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 6/15/24.
//

import Combine
import Foundation

final class ActivityPlaceSettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didchangeText: AnyPublisher<String?, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
        let didTapXButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completedText: AnyPublisher<String, Never>
        let dismiss: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let placeTextSubject = CurrentValueSubject<String?, Never>(nil)
        
        input.didchangeText
            .sink(receiveValue: placeTextSubject.send)
            .store(in: &cancellables)
        
        let isEnableCompleteButton = placeTextSubject
            .compactMap { $0 }
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        let text = input.didTapCompleteButton
            .map { placeTextSubject.value }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            isEnableCompleteButton: isEnableCompleteButton,
            completedText: text,
            dismiss: input.didTapXButton
        )
    }
}
