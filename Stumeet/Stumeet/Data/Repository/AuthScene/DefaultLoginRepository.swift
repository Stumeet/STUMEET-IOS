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
        
    init(provider: MoyaProvider<AuthService>) {
        self.provider = provider
    }
    
    func requestLogin() -> AnyPublisher<SessionTokens, MoyaError> {
        return provider.requestPublisher(.login)
            .map(ResponseWithDataDTO<SessionTokensDTO>.self)
            .compactMap { $0.data?.toDomain()}
            .catch { error -> AnyPublisher<SessionTokens, MoyaError> in
                print("Error: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}
