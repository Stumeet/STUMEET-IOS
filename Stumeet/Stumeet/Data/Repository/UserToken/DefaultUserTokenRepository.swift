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
        
    init(provider: MoyaProvider<UserTokenService>) {
        self.provider = provider
    }
    
    func updateAccessToken(accessToken: String, refreshToken: String) -> AnyPublisher<AccessToken, MoyaError> {
        let requestDTO = TokensRequestDTO(accessToken: accessToken, refreshToken: refreshToken)
        return provider.requestPublisher(.tokens(requestDTO))
            .map(ResponseWithDataDTO<AccessTokenDTO>.self)
            .compactMap { $0.data?.toDomain() }
            .catch { error -> AnyPublisher<AccessToken, MoyaError> in
                print("Error: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}

