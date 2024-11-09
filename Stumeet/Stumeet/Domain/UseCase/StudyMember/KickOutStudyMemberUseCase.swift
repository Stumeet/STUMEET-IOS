//
//  KickOutStudyMemberUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/31.
//

import Combine

protocol KickOutStudyMemberUseCase {
    func execute(studyID: Int, memberID: Int) -> AnyPublisher<Bool, Never>
}

final class DefaultKickOutStudyMemberUseCase: KickOutStudyMemberUseCase {
    private let repository: StudyMemberRepository

    init(repository: StudyMemberRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, memberID: Int) -> AnyPublisher<Bool, Never> {
        return repository.removeStudyMember(studyID: studyID, memberID: memberID)
            .catch { error -> AnyPublisher<Bool, Never> in
                print("error: \(error)")
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
