//
//  SnsLoginViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Foundation
import Combine

typealias AuthUseCase = LoginUseCase

final class SnsLoginViewModel: ViewModelType {
    
    // MARK: - Input
    struct Input {
        let loginType: AnyPublisher<LoginType, Never>
    }
    
    // MARK: - Output
    struct Output {
        let authStateNavigation: AnyPublisher<LoginProcessResult, Never>
        let showError: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    private let showErrorSubject = PassthroughSubject<String, Never>()
    private var useCase: AuthUseCase
    
    // MARK: - Init
    init(useCase: AuthUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        let navigateToChangeProfileVC = input.loginType
            .flatMap { [weak self] type -> AnyPublisher<LoginProcessResult, Never> in
                guard let self = self
                else { return Empty().eraseToAnyPublisher() }
                
                return useCase.signIn(loginType: type)}
            .map { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            authStateNavigation: navigateToChangeProfileVC,
            showError: showErrorSubject.eraseToAnyPublisher()
        )
    }
}
