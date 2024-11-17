//
//  FetchActiveStudyMembersUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/14.
//


import Combine

protocol FetchActiveStudyMembersUseCase {
    func execute(studyID: Int, activityID: Int) -> AnyPublisher<[DetailActivityMember], Never>
}

final class DefaultFetchActiveStudyMembersUseCase: FetchActiveStudyMembersUseCase {
    private let repository: DetailActivityMemberListRepository
    
    init(repository: DetailActivityMemberListRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, activityID: Int) -> AnyPublisher<[DetailActivityMember], Never> {
        return repository.fetchMembers(studyID: studyID, activityID: activityID)
            .catch { error -> AnyPublisher<[DetailActivityMember], Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
    }
}
