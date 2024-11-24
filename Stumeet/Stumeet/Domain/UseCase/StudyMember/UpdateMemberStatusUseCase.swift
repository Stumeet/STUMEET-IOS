//
//  UpdateMemberStatusUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/18.
//

import Combine

protocol UpdateMemberStatusUseCase {
    func execute(
        studyID: Int,
        activityID: Int,
        participantID: Int,
        status: String
    ) -> AnyPublisher<Bool, Never>
}

final class DefaultUpdateMemberStatusUseCase: UpdateMemberStatusUseCase {
    private let repository: StudyMemberRepository

    init(repository: StudyMemberRepository) {
        self.repository = repository
    }

    func execute(
        studyID: Int,
        activityID: Int,
        participantID: Int,
        status: String
    ) -> AnyPublisher<Bool, Never> {
        return repository.updateMemberActivityStatus(
            studyID: studyID,
            activityID: activityID,
            participantID: participantID,
            status: status
        )
            .catch { error -> AnyPublisher<Bool, Never> in
                print("error: \(error)")
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
