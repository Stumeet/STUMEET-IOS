//
//  TokenUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Combine
import Foundation

protocol TokenUseCase {
    func refreshToken(accessToken: String, refreshToken: String) -> AnyPublisher<Bool, Never>
}

final class DefaultTokenUseCase: TokenUseCase {
    private let repository: UserTokenRepository
    
    init(repository: UserTokenRepository
    ) {
        self.repository = repository
    }
    
    func refreshToken(accessToken: String, refreshToken: String) -> AnyPublisher<Bool, Never> {
        return repository.updateAccessToken(accessToken: accessToken, refreshToken: refreshToken)
            .catch { _ in Just(false).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}
