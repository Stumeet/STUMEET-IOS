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
    func setPresentedImage(indexPath: IndexPath, items: [DetailStudyActivitySectionItem]) -> AnyPublisher<([String], Int), Never>
    func setPresentedNames(items: [DetailStudyActivitySectionItem]) -> AnyPublisher<[String], Never>
}


final class DefaultDetailStudyActivityUseCase: DetailStudyActivityUseCase {
    
    private let repository: DetailStudyActivityRepository
    
    init(repository: DetailStudyActivityRepository) {
        self.repository = repository
    }
    
    func setDetailActivityItem() -> AnyPublisher<[DetailStudyActivitySectionItem], Never> {
        return repository.fetchDetailActivityItems()
    }
    
    func setPresentedImage(indexPath: IndexPath, items: [DetailStudyActivitySectionItem]) -> AnyPublisher<([String], Int), Never> {
        let images = items
            .compactMap { if case .photoCell(let item) = $0 { return item.imageURL }
                return nil
            }

        let selectedRow = indexPath.item
        
        return Just((images, selectedRow)).eraseToAnyPublisher()
    }
    
    func setPresentedNames(items: [DetailStudyActivitySectionItem]) -> AnyPublisher<[String], Never> {
        let images = items
            .compactMap { if case .photoCell(let item) = $0 { return item.imageURL }
                return nil
            }
        return Just(images).eraseToAnyPublisher()
    }
}
