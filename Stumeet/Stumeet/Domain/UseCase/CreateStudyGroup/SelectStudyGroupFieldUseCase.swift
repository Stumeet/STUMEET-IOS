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
    func getSelectedFields(indexPath: IndexPath, fields: [StudyField]) -> AnyPublisher<[StudyField], Never>
    func getIsEnableCompleteButton(fields: [StudyField]) -> AnyPublisher<Bool, Never>
    func getSelectedField(fields: [StudyField]) -> AnyPublisher<StudyField, Never>
}

final class DefaultSelectStudyGroupFieldUseCase: SelectStudyGroupFieldUseCase {
    
    private let repository: SelectStudyGroupFieldRepository
    
    init(repository: SelectStudyGroupFieldRepository) {
        self.repository = repository
    }
    
    func getFieldItems() -> AnyPublisher<[StudyField], Never> {
        return repository.getFieldItems()
    }
    
    func getSelectedFields(indexPath: IndexPath, fields: [StudyField]) -> AnyPublisher<[StudyField], Never> {
        var selectedFields = fields
        
        selectedFields[indexPath.item].isSelected.toggle()
        if selectedFields[indexPath.item].isSelected {
            for index in selectedFields.indices where index != indexPath.item {
                selectedFields[index].isSelected = false
            }
        }
        
        return Just(selectedFields).eraseToAnyPublisher()
    }
    
    func getIsEnableCompleteButton(fields: [StudyField]) -> AnyPublisher<Bool, Never> {
        Just(fields.contains(where: { $0.isSelected }))
            .eraseToAnyPublisher()
    }
    
    func getSelectedField(fields: [StudyField]) -> AnyPublisher<StudyField, Never> {
        return Just(fields.filter { $0.isSelected }.first!).eraseToAnyPublisher()
    }
}
