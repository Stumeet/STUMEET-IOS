//
//  DelegateStudyAdminUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/04.
//

import Combine

protocol DelegateStudyAdminUseCase {
    func execute(studyID: Int, memberID: Int) -> AnyPublisher<Bool, Never>
}

final class DefaultDelegateStudyAdminUseCase: DelegateStudyAdminUseCase {
    private let repository: StudyMemberRepository

    init(repository: StudyMemberRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, memberID: Int) -> AnyPublisher<Bool, Never> {
        return repository.delegateAdminRights(studyID: studyID, memberID: memberID)
            .catch { error -> AnyPublisher<Bool, Never> in
                print("error: \(error)")
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
