//
//  LoginUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Combine
import Foundation

protocol LoginUseCase {
    func signIn(loginType: LoginType) -> AnyPublisher<Bool, Error>
}

final class DefaultLoginUseCase: LoginUseCase {
    private let service: LoginService
    private let repository: LoginRepository
    private var keychainManager: KeychainManageable
    
    init(service: LoginService,
         repository: LoginRepository,
         keychainManager: KeychainManageable
    ) {
        self.service = service
        self.repository = repository
        self.keychainManager = keychainManager
    }

    func signIn(loginType: LoginType) -> AnyPublisher<Bool, Error> {
        return service.fetchAuthToken()
            .flatMap { [weak self] snsToken -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                // SNS 토큰을 Keychain에 저장
                let isTokenSaved = self.keychainManager.saveToken(snsToken, for: .loginSnsToken)
                guard isTokenSaved else {
                    return Empty().eraseToAnyPublisher()
                }
                
                // SNS 토큰 저장 성공 후 로그인 요청
                return self.repository.requestLogin(loginType: loginType)
                    .map { data in
                        // AccessToken을 Keychain에 저장
                        return self.keychainManager.saveToken(data.accessToken, for: .accessToken) &&
                        self.keychainManager.saveToken(data.refreshToken, for: .refreshToken)
                    }
                    .catch { error in
                        Fail(error: error).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
