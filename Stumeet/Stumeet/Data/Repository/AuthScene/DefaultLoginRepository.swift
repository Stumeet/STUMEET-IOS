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
    
    // TODO: - error 처리
    func requestLogin(loginType: LoginType, snsToken: String) -> AnyPublisher<UserAuthInfo, Never> {
        return provider.requestPublisher(.login(loginType, snsToken))
            .map(ResponseWithDataDTO<OauthResponseDTO>.self)
            .compactMap { $0.data?.toDomain()}
            .replaceError(with: nil)
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
    }
}
