//
//  CheckAdminUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/20.
//

import Combine

protocol CheckAdminUseCase {
    func execute(studyID: Int) -> AnyPublisher<Bool, Never>
}

class DefaultCheckAdminUseCase: CheckAdminUseCase {
    private let repository: StudyMemberRepository

    init(repository: StudyMemberRepository) {
        self.repository = repository
    }

    func execute(studyID: Int) -> AnyPublisher<Bool, Never> {
        return repository.checkIfAdmin(studyID: studyID)
            .catch { error -> AnyPublisher<Bool, Never> in
                print("error: \(error)")
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
