//
//  FetchClosestActivityUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/02/02.
//

import Combine

protocol FetchClosestActivityUseCase {
    func execute() -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchClosestActivityUseCase: FetchClosestActivityUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<ActivityPage, Never> {
        return repository.fetchBriefActivityList(
            size: 1,
            page: 1,
            isNotice: false,
            studyId: nil,
            memberId: nil,
            category: [.homework, .meeting],
            fromDate: nil,
            toDate: nil,
            sort: .specific
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }
}
