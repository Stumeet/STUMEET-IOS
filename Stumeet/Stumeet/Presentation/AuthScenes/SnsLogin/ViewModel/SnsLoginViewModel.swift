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
        let navigateToChangeProfileVC: AnyPublisher<Void, Never>
        let showError: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    private let showErrorSubject = PassthroughSubject<String, Never>()
    private var useCase: AuthUseCase!
    private var repository: LoginRepository
    private var keychainManager: KeychainManageable
    
    // MARK: - Init
    init(repository: LoginRepository,
         keychainManager: KeychainManageable) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        let navigateToChangeProfileVC = input.loginType
            .flatMap { [weak self] type -> AnyPublisher<Bool, Error> in
                guard let self = self
                else { return Empty().eraseToAnyPublisher() }
                let service: LoginService = self.service(for: type)
                self.useCase = DefaultLoginUseCase(service: service, repository: self.repository, keychainManager: self.keychainManager)
                
                return useCase.signIn(loginType: type)}
            .catch { [weak self] error -> AnyPublisher<Bool, Never> in
                guard let self = self
                else { return Just(false).eraseToAnyPublisher() }
                print("Login error: \(error)")
                // TODO: 에러 케이스는 모아서 정리 필요
                self.showErrorSubject.send(error.localizedDescription)
                
                return Just(false).eraseToAnyPublisher()
            }
            .filter { $0 == true }
            .map { _ in }
            .eraseToAnyPublisher()
        
        return Output(
            navigateToChangeProfileVC: navigateToChangeProfileVC,
            showError: showErrorSubject.eraseToAnyPublisher()
        )
    }

    private func service(for type: LoginType) -> LoginService {
        switch type {
        case .apple: return AppleLoginService()
        case .kakao: return KakaoLoginService()
        }
    }
}

enum LoginType {
    case apple
    case kakao
    
    var korean: String {
        switch self {
        case .apple:
            return "애플"
        case .kakao:
            return "카카오"
        }
    }
    
    var english: String {
        switch self {
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        }
    }
}
