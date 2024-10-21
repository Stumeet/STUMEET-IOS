//
//  FetchStudyMemberDetailUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/20.
//

import Combine

protocol FetchStudyMemberDetailUseCase {
    func execute(studyID: Int, memberID: Int) -> AnyPublisher<StudyMember, Never>
}

final class DefaultFetchStudyMemberDetailUseCase: FetchStudyMemberDetailUseCase {
    private let repository: StudyMemberRepository

    init(repository: StudyMemberRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, memberID: Int) -> AnyPublisher<StudyMember, Never> {
        return repository.fetchStudyMemberDetailInfo(studyID: studyID, memberID: memberID)
            .catch { error -> AnyPublisher<StudyMember, Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
    }
}
