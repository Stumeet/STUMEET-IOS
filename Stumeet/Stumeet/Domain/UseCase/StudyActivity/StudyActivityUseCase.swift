//
//  StudyActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

protocol StudyActivityUseCase {
    func getActivityItems(type: StudyActivitySectionItem) -> AnyPublisher<[StudyActivitySectionItem], Never>
}

final class DefaultStudyActivityUseCase: StudyActivityUseCase {
    
    private let repository: StudyActivityRepository
    
    init(repository: StudyActivityRepository) {
        self.repository = repository
    }
    
    func getActivityItems(type: StudyActivitySectionItem) -> AnyPublisher<[StudyActivitySectionItem], Never> {
        return repository.fetchActivityItems(type: type)
    }
    
    
}
