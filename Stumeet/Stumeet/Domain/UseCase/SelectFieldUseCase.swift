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
        return repository.selectField(at: indexPath)
    }
}
