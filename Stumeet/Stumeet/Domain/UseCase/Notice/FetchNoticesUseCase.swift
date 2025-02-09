//
//  FetchNoticesUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/11.
//

import Combine

protocol FetchNoticesUseCase {
    func execute(page: Int, studyID: Int?) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchNoticesUseCase: FetchNoticesUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute(page: Int, studyID: Int? = nil) -> AnyPublisher<ActivityPage, Never> {
        return repository.fetchActivityList(
            size: 15,
            page: page,
            isNotice: true,
            studyId: studyID,
            category: nil,
            sort: nil
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }
}
