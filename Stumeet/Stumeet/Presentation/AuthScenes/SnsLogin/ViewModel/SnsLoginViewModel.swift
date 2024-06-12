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
        let navigateToChangeProfileVC: AnyPublisher<Bool, Never>
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
            .flatMap { [weak self] type -> AnyPublisher<Bool, Error> in
                guard let self = self
                else { return Empty().eraseToAnyPublisher() }
                
                return useCase.signIn(loginType: type)}
            .catch { [weak self] error -> AnyPublisher<Bool, Never> in
                guard let self = self
                else { return Just(false).eraseToAnyPublisher() }
                print("Login error: \(error)")
                // TODO: 에러 케이스는 모아서 정리 필요
                self.showErrorSubject.send(error.localizedDescription)
                
                return Just(false).eraseToAnyPublisher()
            }.map { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            navigateToChangeProfileVC: navigateToChangeProfileVC,
            showError: showErrorSubject.eraseToAnyPublisher()
        )
    }
}
