//
//  DefaultLoginRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/17.
//

import Moya
import CombineMoya
import Combine

class DefaultLoginRepository: LoginRepository {
    private let provider: MoyaProvider<AuthService>
    private let keychainManager: KeychainManageable
    
    init(provider: MoyaProvider<AuthService>,
         keychainManager: KeychainManageable
    ) {
        self.provider = provider
        self.keychainManager = keychainManager
    }
    
    func requestLogin(loginType: LoginType, snsToken: String) -> AnyPublisher<Bool, MoyaError> {
        return provider.requestPublisher(.login(loginType, snsToken))
            .map(ResponseWithDataDTO<OauthResponseDTO>.self)
            .compactMap { $0.data?.toDomain()}
            .map { [weak self] result in
                guard let self = self else { return false }
                let isTokenSaved = keychainManager.saveToken(result.authTokens)
                let isNewUser = result.isFirstLogin
                
                return isTokenSaved && !isNewUser
            }
            .catch { error -> AnyPublisher<Bool, MoyaError> in
                print("Error: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}
