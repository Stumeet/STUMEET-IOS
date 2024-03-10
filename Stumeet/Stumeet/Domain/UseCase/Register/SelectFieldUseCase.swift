//
//  SelectFieldUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

protocol SelectFieldUseCase {
    func getFields() -> AnyPublisher<[Field], Never>
    func selectField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never>
    func fetchSearchedField(text: String) -> AnyPublisher<[Field], Never>
    func addField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never>
}

final class DefaultSelectFieldUseCase: SelectFieldUseCase {
    
    let repository: SelecteFieldRepository
    
    init(repository: SelecteFieldRepository) {
        self.repository = repository
    }
    
    func getFields() -> AnyPublisher<[Field], Never> {
        return repository.getFields()
    }
    
    func selectField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never> {
        repository.getFields()
            .first()
            .map { fields in
                var updatedFields = fields
                for index in updatedFields.indices {
                    updatedFields[index].isSelected = updatedFields[index] == updatedFields[indexPath.row]
                }
                self.repository.updateField(fields: updatedFields)
                return updatedFields
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSearchedField(text: String) -> AnyPublisher<[Field], Never> {
        return repository.fetchAddableFields()
            .first()
            .map { fields in
                let filteredFields = fields.filter { $0.name.contains(text) }
                self.repository.updateSearchedField(filteredFields: filteredFields)
                return filteredFields
            }
            .eraseToAnyPublisher()
    }
    
    func addField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never> {
        return repository.fetchSearchedField()
            .first()
            .flatMap { [weak self] searchedFields -> AnyPublisher<[Field], Never> in
                guard let self = self else {
                    return Just([]).eraseToAnyPublisher()
                }
                let selectedField = searchedFields[indexPath.row]

                return self.updateSearchedFieldToField(selectedField: selectedField)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Function

extension DefaultSelectFieldUseCase {
    private func updateSearchedFieldToField(selectedField: Field) -> AnyPublisher<[Field], Never> {
        return repository.getFields()
            .first()
            .map { existingFields in
                var updatedFields = existingFields
                var newField = selectedField
                
                // 검색 리스트 중 1차 분야에 존재하는 분야를 선택했을 때
                if existingFields.contains(where: { $0.id == selectedField.id }) {
                    updatedFields.removeAll(where: { $0.id == selectedField.id })
                }
                
                for index in updatedFields.indices where(updatedFields[index].isSelected) {
                    updatedFields[index].isSelected = false
                }
                
                newField.isSelected = true
                updatedFields.insert(newField, at: 0)
                self.repository.updateField(fields: updatedFields)
                return updatedFields
            }
            .eraseToAnyPublisher()
    }
}
