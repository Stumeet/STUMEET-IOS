//
//  LoginUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Combine
import Foundation

protocol LoginUseCase {
    func signIn() -> AnyPublisher<Bool, Error>
}

final class DefaultLoginUseCase: LoginUseCase {
    private let service: LoginService
    private let repository: LoginRepository
    
    init(service: LoginService,
         repository: LoginRepository
    ) {
        self.service = service
        self.repository = repository
    }

    func signIn() -> AnyPublisher<Bool, Error> {
        return service.fetchAuthToken()
            .flatMap { [weak self] snsToken -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                // SNS 토큰을 Keychain에 저장
                let isTokenSaved = KeychainManager.shared.saveToken(snsToken, for: PrototypeAPIConst.loginSnsToken)
                guard isTokenSaved else {
                    return Empty().eraseToAnyPublisher()
                }
                
                // SNS 토큰 저장 성공 후 로그인 요청
                return self.repository.requestLogin()
                    .map { data in
                        guard let accessToken = data.data?.accessToken
                        else { return false }
                        
                        // AccessToken을 Keychain에 저장
                        return KeychainManager.shared.saveToken(accessToken, for: PrototypeAPIConst.accessToken)
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
