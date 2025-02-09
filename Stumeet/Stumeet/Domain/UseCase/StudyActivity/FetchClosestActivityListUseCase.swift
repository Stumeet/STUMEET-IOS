//
//  FetchClosestActivityListUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/02/02.
//

import Combine

protocol FetchClosestActivityListUseCase {
    func execute(page: Int) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchClosestActivityListUseCase: FetchClosestActivityListUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute(page: Int) -> AnyPublisher<ActivityPage, Never> {
        return repository.fetchBriefActivityList(
            size: 20,
            page: page,
            isNotice: false,
            studyId: nil,
            memberId: nil,
            category: [.homework, .meeting],
            fromDate: nil,
            toDate: nil,
            sort: .specific
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            return Just(ActivityPage(
                pageInfo: PageInfo(totalPages: 0, totalElements: 0, currentPage: 0, pageSize: 0),
                activitys: []
            )).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
