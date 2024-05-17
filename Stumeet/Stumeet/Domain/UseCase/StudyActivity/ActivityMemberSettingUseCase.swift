// ActivityMemberSettingUseCase.swift

import Combine
import Foundation

protocol ActivityMemberSettingUseCase {
    func getMembers() -> AnyPublisher<[String], Never>
    func toggleSelection(in indexPaths: Set<IndexPath>, for selectedIndexPath: IndexPath) -> (Set<IndexPath>, IndexPath, Bool)
}

final class DefaultActivityMemberSettingUseCase: ActivityMemberSettingUseCase {
    private let repository: ActivityMemberSettingRepository
    
    init(repository: ActivityMemberSettingRepository) {
        self.repository = repository
    }
    
    func getMembers() -> AnyPublisher<[String], Never> {
        return repository.fetchMembers()
    }
    
    func toggleSelection(in indexPaths: Set<IndexPath>, for selectedIndexPath: IndexPath) -> (Set<IndexPath>, IndexPath, Bool) {
        var indexPaths = indexPaths
        let isSelected = !indexPaths.contains(selectedIndexPath)
        
        if isSelected {
            indexPaths.insert(selectedIndexPath)
        } else {
            indexPaths.remove(selectedIndexPath)
        }
        
        return (indexPaths, selectedIndexPath, isSelected)
    }
}
