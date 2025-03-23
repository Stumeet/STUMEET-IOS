//
//  DefaultUserRepository.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Moya
import CombineMoya
import Combine

final class DefaultUserRepository: UserRepository {
    
    private let provider: MoyaProvider<AuthService>
    
    init(provider: MoyaProvider<AuthService>) {
        self.provider = provider
    }
    
    func fetchMyProfile() -> AnyPublisher<UserProfile, Moya.MoyaError> {
        return provider.requestPublisher(.fetchMyProfile)
            .map(ResponseWithDataDTO<FetchMyProfileResponseDTO>.self)
            .compactMap { $0.data?.toDomain() }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
