//
//  LoginUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Combine
import Foundation

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

enum LoginProcessResult {
    case signUp
    case loginSuccess
    case none
}

protocol LoginUseCase {
    func signIn(loginType: LoginType) -> AnyPublisher<LoginProcessResult, Never>
}

final class DefaultLoginUseCase: LoginUseCase {
    private var kakaoLoginService: LoginService
    private var appleLoginService: LoginService
    private let repository: LoginRepository
    private let keychainManager: KeychainManageable
    
    init(kakaoLoginService: LoginService,
         appleLoginService: LoginService,
         repository: LoginRepository,
         keychainManager: KeychainManageable
    ) {
        self.kakaoLoginService = kakaoLoginService
        self.appleLoginService = appleLoginService
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func signIn(loginType: LoginType) -> AnyPublisher<LoginProcessResult, Never> {
        let selectedService: LoginService = {
            switch loginType {
            case .kakao:
                return kakaoLoginService
            case .apple:
                return appleLoginService
            }
        }()
        
        return processLogin(with: selectedService, loginType: loginType)
    }
    
    private func processLogin(with service: LoginService, loginType: LoginType) -> AnyPublisher<LoginProcessResult, Never> {
        return service.fetchAuthToken()
            .flatMap { [weak self] snsToken -> AnyPublisher<LoginProcessResult, Never> in
                guard let self = self else {
                    return Just(.none).eraseToAnyPublisher()
                }
                
                return repository.requestLogin(loginType: loginType, snsToken: snsToken)
                    .map { [weak self] result in
                        guard let self = self,
                              keychainManager.saveToken(result.authTokens)
                        else { return .none }
                        
                        return result.isFirstLogin ? .signUp : .loginSuccess
                    }
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<LoginProcessResult, Never> in
                print(error)
                return Just(.none).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
