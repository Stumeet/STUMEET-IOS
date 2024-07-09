//
//  MyStudyGroupListUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/04.
//

import Combine

protocol MyStudyGroupListUseCase {
    func getStudyGroupItems(type: String) -> AnyPublisher<[StudyGroup], Never>
}

final class DefaultMyStudyGroupListUseCase: MyStudyGroupListUseCase {
    
    private let repository: MyStudyGroupListRepository
    
    init(repository: MyStudyGroupListRepository) {
        self.repository = repository
    }
    
    func getStudyGroupItems(type: String) -> AnyPublisher<[StudyGroup], Never> {
        return repository.fetchJoinedStudyGroups(type: type)
            .catch { error -> AnyPublisher<[StudyGroup], Never> in
                print("error: \(error)")
                return Just([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}
