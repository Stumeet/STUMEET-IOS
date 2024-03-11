//
//  StartViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/11/24.
//

import Combine
import Foundation

final class StartViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapStartButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isNaviteToTabBar: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: StartUseCase
    private let register: Register
    
    // MARK: - Init
    
    init(useCase: StartUseCase, register: Register) {
        self.useCase = useCase
        self.register = register
        print(register)
    }
    
    func transform(input: Input) -> Output {
        
        let isNavigateToTabBar = input.didTapStartButton
            .flatMap { [weak self] _ in
                guard let self = self else { return Just(false).eraseToAnyPublisher() }
                return self.useCase.signUp(register: self.register)
            }
            .eraseToAnyPublisher()
        
        
        return Output(isNaviteToTabBar: isNavigateToTabBar)
    }
}
