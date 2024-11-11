//
//  FetchAllStudyActivitiesUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/11.
//

import Combine

protocol FetchAllStudyActivitiesUseCase {
    func execute(studyID: Int, page: Int, category: ActivityCategory) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchAllStudyActivitiesUseCase: FetchAllStudyActivitiesUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, page: Int, category: ActivityCategory) -> AnyPublisher<ActivityPage, Never> {
            return repository.fetchActivityList(
                size: 20,
                page: page,
                isNotice: false,
                studyId: studyID,
                category: category
            )
            .catch { error -> AnyPublisher<ActivityPage, Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
        }
}
