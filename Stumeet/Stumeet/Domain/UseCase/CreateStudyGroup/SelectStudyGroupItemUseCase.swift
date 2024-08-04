//
//  SelectStudyGroupItemUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

protocol SelectStudyGroupItemUseCase {
    func getItems(type: CreateStudySelectItemType) -> AnyPublisher<[SelectStudyItem], Never>
    func getSelectedItems(indexPath: IndexPath, items: [SelectStudyItem]) -> AnyPublisher<[SelectStudyItem], Never>
    func getIsEnableCompleteButton(items: [SelectStudyItem]) -> AnyPublisher<Bool, Never>
    func getSelectedItem(items: [SelectStudyItem]) -> AnyPublisher<SelectStudyItem, Never>
}

final class DefaultSelectStudyItemUseCase: SelectStudyGroupItemUseCase {
    
    private let repository: SelectStudyGroupItemRepository
    
    init(repository: SelectStudyGroupItemRepository) {
        self.repository = repository
    }
    
    func getItems(type: CreateStudySelectItemType) -> AnyPublisher<[SelectStudyItem], Never> {
        switch type {
        case .field:
            return repository.getFieldItems()
        case .region:
            return repository.getRegionItems()
        }
    }
    
    func getSelectedItems(indexPath: IndexPath, items: [SelectStudyItem]) -> AnyPublisher<[SelectStudyItem], Never> {
        var selectedItems = items
        
        selectedItems[indexPath.item].isSelected.toggle()
        if selectedItems[indexPath.item].isSelected {
            for index in selectedItems.indices where index != indexPath.item {
                selectedItems[index].isSelected = false
            }
        }
        
        return Just(selectedItems).eraseToAnyPublisher()
    }
    
    func getIsEnableCompleteButton(items: [SelectStudyItem]) -> AnyPublisher<Bool, Never> {
        Just(items.contains(where: { $0.isSelected }))
            .eraseToAnyPublisher()
    }
    
    func getSelectedItem(items: [SelectStudyItem]) -> AnyPublisher<SelectStudyItem, Never> {
        return Just(items.filter { $0.isSelected }.first!).eraseToAnyPublisher()
    }
}
