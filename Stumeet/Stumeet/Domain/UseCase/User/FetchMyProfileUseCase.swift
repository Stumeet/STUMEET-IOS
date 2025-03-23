//
//  FetchMyProfileUseCase.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Combine

protocol FetchMyProfileUseCase {
    func execute() -> AnyPublisher<UserProfile, Never>
}

final class DefaultFetchMyProfileUseCase: FetchMyProfileUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<UserProfile, Never> {
        return repository.fetchMyProfile()
            .catch { error -> AnyPublisher<UserProfile, Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
    }
}
