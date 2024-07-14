//
//  StudyActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

protocol StudyActivityUseCase {
    func getAllActivityItems(items: [StudyActivitySectionItem]) -> AnyPublisher<[Activity], Never>
    func getGroupActivityItems(items: [StudyActivitySectionItem]) -> AnyPublisher<[Activity], Never>
    func getTaskActivityItems(items: [StudyActivitySectionItem]) -> AnyPublisher<[Activity], Never>
    func getSelectedActivityID(selectedIndexPath: IndexPath, items: [StudyActivitySectionItem]?) -> AnyPublisher<(Int, Int), Never>
}

final class DefaultStudyActivityUseCase: StudyActivityUseCase {
    
    private let repository: StudyActivityRepository
    
    init(repository: StudyActivityRepository) {
        self.repository = repository
    }
    
    func getAllActivityItems(items: [StudyActivitySectionItem]) -> AnyPublisher<[Activity], Never> {
        let size = 4
        let nextPage = getNextPage(for: items, size: size)
        return repository.fetchAllActivityItems(size: size, page: nextPage)
            .map { items.map { $0.item } + $0 }
            .eraseToAnyPublisher()
    }
    
    func getGroupActivityItems(items: [StudyActivitySectionItem]) -> AnyPublisher<[Activity], Never> {
        let size = 9
        let nextPage = getNextPage(for: items, size: size)
        return repository.fetchGroupActivityItems(size: size, page: nextPage)
            .map { items.map { $0.item } + $0 }
            .eraseToAnyPublisher()
    }
    
    func getTaskActivityItems(items: [StudyActivitySectionItem]) -> AnyPublisher<[Activity], Never> {
        let size = 9
        let nextPage = getNextPage(for: items, size: size)
        return repository.fetchTaskActivityItems(size: size, page: nextPage)
            .map { items.map { $0.item } + $0 }
            .eraseToAnyPublisher()
    }
    
    func getSelectedActivityID(selectedIndexPath: IndexPath, items: [StudyActivitySectionItem]?) -> AnyPublisher<(Int, Int), Never> {
        guard let items = items else { return Empty().eraseToAnyPublisher() }
        // TODO: - studyID:1 테스트용이므로 추후에 변경
        let selectedID = (1, items[selectedIndexPath.item].item.id)
        return Just(selectedID).eraseToAnyPublisher()
    }
}

// MARK: - Function

extension DefaultStudyActivityUseCase {
    private func getNextPage(for items: [StudyActivitySectionItem], size: Int) -> Int {
        let additionalPage = items.count % size == 0 ? 0 : 1
        return items.isEmpty ? 0 : items.count / size + additionalPage
    }
}
