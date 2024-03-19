//
//  DefaultLoginRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/17.
//

import Moya
import CombineMoya
import Combine

protocol LoginRepository {
    func requestLogin() -> AnyPublisher<PrototypeAPIData<PrototypeOauth>, MoyaError>
}

class DefaultLoginRepository: LoginRepository {
    private let provider: MoyaProvider<PrototypeAPIService>
    
    init(provider: MoyaProvider<PrototypeAPIService>) {
        self.provider = provider
    }
    
    func requestLogin() -> AnyPublisher<PrototypeAPIData<PrototypeOauth>, MoyaError> {
        return provider.requestPublisher(.login)
            .map(PrototypeAPIData<PrototypeOauth>.self)
            .catch { error -> AnyPublisher<PrototypeAPIData<PrototypeOauth>, MoyaError> in
                print("Error: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
}
