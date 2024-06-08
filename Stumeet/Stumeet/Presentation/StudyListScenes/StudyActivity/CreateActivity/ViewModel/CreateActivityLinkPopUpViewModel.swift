//
//  CreateActivityLinkPopUpViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 6/7/24.
//

import Combine
import Foundation

final class CreateActivityLinkPopUpViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didBegienEditing: AnyPublisher<Void, Never>
        let didChangedText: AnyPublisher<String?, Never>
        let didTapXButton: AnyPublisher<Void, Never>
        let didTapRegisterButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isEnableRegisterButton: AnyPublisher<Bool, Never>
        let registerLink: AnyPublisher<String, Never>
        let dismiss: AnyPublisher<Void, Never>
        let updateConstraintContainerView: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let textSubject = CurrentValueSubject<String, Never>("")
        
        input.didChangedText
            .compactMap { $0 }
            .sink(receiveValue: textSubject.send)
            .store(in: &cancellables)
        
        let isEnable = textSubject
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        let registerLink = input.didTapRegisterButton
            .map { textSubject.value }
            .eraseToAnyPublisher()
        
        let updateConstraint = input.didBegienEditing
            .eraseToAnyPublisher()
        
        let dismiss = input.didTapXButton
        
        return Output(
            isEnableRegisterButton: isEnable,
            registerLink: registerLink,
            dismiss: dismiss,
            updateConstraintContainerView: updateConstraint
        )
    }
}
