//
//  FetchStudyMemberMeetingsUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/29.
//

import Combine

protocol FetchStudyMemberActivityUseCase {
    func execute(studyID: Int, memberID: Int, page: Int, category: ActivityCategory) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchStudyMemberActivityUseCase: FetchStudyMemberActivityUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, memberID: Int, page: Int, category: ActivityCategory) -> AnyPublisher<ActivityPage, Never> {
        return repository.fetchBriefActivityList(
            size: 20,
            page: page,
            isNotice: false,
            studyId: studyID,
            memberId: memberID,
            category: category,
            fromDate: nil,
            toDate: nil
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }
}
