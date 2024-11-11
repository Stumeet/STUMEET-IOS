//
//  FetchLatestNoticeUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/11.
//

import Combine

protocol FetchLatestNoticeUseCase {
    func execute(studyID: Int) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchLatestNoticeUseCase: FetchLatestNoticeUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute(studyID: Int) -> AnyPublisher<ActivityPage, Never> {
        return repository.fetchActivityList(
            size: 1,
            page: 0,
            isNotice: true,
            studyId: studyID,
            category: nil
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }

}
