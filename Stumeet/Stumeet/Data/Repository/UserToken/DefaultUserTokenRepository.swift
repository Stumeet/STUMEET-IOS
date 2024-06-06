//
//  DefaultUserTokenRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Moya
import CombineMoya
import Combine

class DefaultUserTokenRepository: UserTokenRepository {
    private let provider: MoyaProvider<UserTokenService>
    private let keychainManager: KeychainManageable
        
    init(provider: MoyaProvider<UserTokenService>,
         keychainManager: KeychainManageable
    ) {
        self.provider = provider
        self.keychainManager = keychainManager
    }
    
    func updateAccessToken(accessToken: String, refreshToken: String) -> AnyPublisher<Bool, MoyaError> {
        let requestDTO = TokensRequestDTO(accessToken: accessToken, refreshToken: refreshToken)
        return provider.requestPublisher(.tokens(requestDTO))
            .map(ResponseWithDataDTO<AccessTokenDTO>.self)
            .compactMap { $0.data?.toDomain() }
            .map { [weak self] result in
                guard let self = self else { return false}
                return self.keychainManager.saveToken(result.accessToken, for: .accessToken)
            }
            .catch { error -> AnyPublisher<Bool, MoyaError> in
                print("Error: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}

