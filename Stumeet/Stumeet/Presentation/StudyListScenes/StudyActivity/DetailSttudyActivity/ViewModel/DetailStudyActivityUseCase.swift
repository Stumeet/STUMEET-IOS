//
//  DetailStudyActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

protocol DetailStudyActivityUseCase {
    func setDetailActivityItem() -> AnyPublisher<[DetailStudyActivitySectionItem], Never>
}


final class DefaultDetailStudyActivityUseCase: DetailStudyActivityUseCase {
    
    private let repository: DetailStudyActivityRepository
    
    init(repository: DetailStudyActivityRepository) {
        self.repository = repository
    }
    
    func setDetailActivityItem() -> AnyPublisher<[DetailStudyActivitySectionItem], Never> {
        return repository.fetchDetailActivityItems()
    }
}
