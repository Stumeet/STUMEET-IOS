//
//  StudyGroupMainUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Combine

protocol StudyGroupMainUseCase {
    func getStudyGroupDetail(studyId: Int) -> AnyPublisher<StudyGroupDetail, Never>
}

final class DefaultStudyGroupMainUseCase: StudyGroupMainUseCase {
    
    private let repository: StudyGroupMainRepository
    
    init(repository: StudyGroupMainRepository) {
        self.repository = repository
    }
    
    func getStudyGroupDetail(studyId: Int) -> AnyPublisher<StudyGroupDetail, Never> {
        return repository.fetchDetailStudyGroupInfo(studyId: studyId)
            .catch { error -> AnyPublisher<StudyGroupDetail, Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
    }
    
}
