//
//  FetchMemberReviewTagStatsUseCase.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Combine

protocol FetchMemberReviewTagStatsUseCase {
    func execute() -> AnyPublisher<(Int, [ReviewTag]), Never>
}

final class DefaultFetchMemberReviewTagStatsUseCase: FetchMemberReviewTagStatsUseCase {
    private let repository: MemberReviewRepository

    init(repository: MemberReviewRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<(Int, [ReviewTag]), Never> {
        return repository.fetchMemberReviewTagStats()
            .catch { error -> AnyPublisher<(Int, [ReviewTag]), Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
    }
}
