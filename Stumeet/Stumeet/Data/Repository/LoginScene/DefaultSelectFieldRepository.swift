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
    private var fieldSubject = CurrentValueSubject<[Field], Never>(Field.list)
    
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
}
