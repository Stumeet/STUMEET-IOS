//
//  DefaultSelectFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

final class DefaultSelectFieldRepository: SelecteFieldRepository {
    
    private var fields: [Field] = Field.list
    private var addableFields: [AddableField] = AddableField.list
    private var searchedFields: [AddableField] = []
    private var fieldSubject = CurrentValueSubject<[Field], Never>(Field.list)
    private var searchedFieldSubject = CurrentValueSubject<[AddableField], Never>([])
    
    func getFields() -> AnyPublisher<[Field], Never> {
        return fieldSubject.eraseToAnyPublisher()
    }
    
    func selectField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never> {
        for index in fields.indices {
            fields[index].isSelected = index == indexPath.row
        }
        fieldSubject.send(fields)
        return fieldSubject.eraseToAnyPublisher()
    }
    
    func getSearchedField(text: String) -> AnyPublisher<[AddableField], Never> {
        searchedFields = []
        for field in addableFields where field.field.contains(text) {
            searchedFields.append(AddableField(field: field.field))
        }
        searchedFieldSubject.send(searchedFields)
        return searchedFieldSubject.eraseToAnyPublisher()
    }
    
    func addField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never> {
        let selectedField = searchedFields[indexPath.row].field
        guard !fields.contains(where: { $0.field == selectedField }) else {
            return fieldSubject.eraseToAnyPublisher()
        }
        
        let field = Field(field: selectedField, isSelected: true)
        for index in fields.indices where fields[index].isSelected {
            fields[index].isSelected = false
        }
        
        fields.insert(field, at: 0)
        fieldSubject.send(fields)
        
        return fieldSubject.eraseToAnyPublisher()
    }
}
