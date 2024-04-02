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
    private let keychainManager: KeychainManageable
    
    init(repository: UserTokenRepository,
         keychainManager: KeychainManageable
    ) {
        self.repository = repository
        self.keychainManager = keychainManager
    }

    
    func refreshToken(accessToken: String, refreshToken: String) -> AnyPublisher<Bool, Never> {
        return repository.updateAccessToken(accessToken: accessToken, refreshToken: refreshToken)
            .map { [weak self] result in
                guard let self = self else { return false}
                return self.keychainManager.saveToken(result.accessToken, for: APIConst.accessToken)
            }
            .catch { _ in Just(false).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}
