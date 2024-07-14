//
//  DetailStudyActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

protocol DetailStudyActivityUseCase {
    func getDetailActivityItem(studyID: Int, activityID: Int) -> AnyPublisher<DetailStudyActivity, Never>
    func setPresentedImage(indexPath: IndexPath, items: [DetailStudyActivitySectionItem]) -> AnyPublisher<([String], Int), Never>
}

final class DefaultDetailStudyActivityUseCase: DetailStudyActivityUseCase {
    
    private let repository: DetailStudyActivityRepository
    
    init(repository: DetailStudyActivityRepository) {
        self.repository = repository
    }
    
    func getDetailActivityItem(studyID: Int, activityID: Int) -> AnyPublisher<DetailStudyActivity, Never> {
        return repository.fetchDetailActivityItems(studyID: studyID, activityID: activityID)
    }
    
    func setPresentedImage(indexPath: IndexPath, items: [DetailStudyActivitySectionItem]) -> AnyPublisher<([String], Int), Never> {
        
        var images: [String] = []
        items.forEach {
            if case .photoCell(let item) = $0, let imageURLs = item?.imageURL {
                images = imageURLs
            }
        }
        
        let selectedRow = indexPath.item
        
        return Just((images, selectedRow))
            .eraseToAnyPublisher()
    }
}
