//
//  SelectStudyGroupItemUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

protocol SelectStudyGroupItemUseCase {
    func getItems(type: CreateStudySelectItemType, selectedItem: String) -> AnyPublisher<[SelectStudyItem], Never>
    func getSelectedItems(indexPath: IndexPath, items: [SelectStudyItem]) -> AnyPublisher<[SelectStudyItem], Never>
    func getIsEnableCompleteButton(items: [SelectStudyItem]) -> AnyPublisher<Bool, Never>
    func getSelectedItem(items: [SelectStudyItem]) -> AnyPublisher<SelectStudyItem, Never>
}

final class DefaultSelectStudyItemUseCase: SelectStudyGroupItemUseCase {
    
    private let repository: SelectStudyGroupItemRepository
    
    init(repository: SelectStudyGroupItemRepository) {
        self.repository = repository
    }
    
    func getItems(type: CreateStudySelectItemType, selectedItem: String) -> AnyPublisher<[SelectStudyItem], Never> {
        switch type {
        case .field:
            return repository.getFieldItems()
                .map { ($0, selectedItem) }
                .map(setInitialSelectedItem)
                .eraseToAnyPublisher()
        case .region:
            return repository.getRegionItems()
                .map { ($0, selectedItem) }
                .map(setInitialSelectedItem)
                .eraseToAnyPublisher()
            
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


// MARK: - Functions

extension DefaultSelectStudyItemUseCase {
    private func setInitialSelectedItem(fields: [SelectStudyItem], selectedItem: String) -> [SelectStudyItem] {
        return fields.map { field in
            var updatedField = field
            updatedField.isSelected = field.name == selectedItem
            return updatedField
        }
    }
}
