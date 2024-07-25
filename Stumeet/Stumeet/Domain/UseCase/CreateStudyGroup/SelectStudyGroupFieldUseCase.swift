//
//  SelectStudyGroupFieldUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

protocol SelectStudyGroupFieldUseCase {
    func getFieldItems() -> AnyPublisher<[StudyField], Never>
}

final class DefaultSelectStudyGroupFieldUseCase: SelectStudyGroupFieldUseCase {
    
    private let repository: SelectStudyGroupFieldRepository
    
    init(repository: SelectStudyGroupFieldRepository) {
        self.repository = repository
    }
    
    func getFieldItems() -> AnyPublisher<[StudyField], Never> {
        return repository.getFieldItems()
    }
}
