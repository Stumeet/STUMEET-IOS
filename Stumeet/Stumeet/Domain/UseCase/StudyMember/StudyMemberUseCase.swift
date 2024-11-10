//
//  StudyMemberUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/25.
//

import Combine

protocol StudyMemberUseCase {
    func getMembers(studyID: Int) -> AnyPublisher<[StudyMember], Never>
}

final class DefaultStudyMemberUseCase: StudyMemberUseCase {
    
    private let repository: StudyMemberRepository
    
    init(repository: StudyMemberRepository) {
        self.repository = repository
    }
    
    func getMembers(studyID: Int) -> AnyPublisher<[StudyMember], Never> {
        return repository.fetchStudyMembers(studyID: studyID)
            .catch { error -> AnyPublisher<[StudyMember], Never> in
                print("error: \(error)")
                return Just([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
