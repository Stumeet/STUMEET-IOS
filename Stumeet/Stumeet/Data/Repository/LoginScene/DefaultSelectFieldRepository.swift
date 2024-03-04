//
//  DefaultSelectFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

import Moya

final class DefaultSelectFieldRepository: SelecteFieldRepository {
    
    private let fieldsSubject = CurrentValueSubject<[Field], Never>(Field.data)
    private let addableFieldSubject = CurrentValueSubject<[Field], Never>([])
    private let filteredFieldSubject = CurrentValueSubject<[Field], Never>([])
    private let provider: MoyaProvider<RegisterService>
    
    init(provider: MoyaProvider<RegisterService>) {
        self.provider = provider
    }
    
    func getFields() -> AnyPublisher<[Field], Never> {
        return fieldsSubject.eraseToAnyPublisher()
    }
    
    func fetchAddableFields() -> AnyPublisher<[Field], Never> {
        if addableFieldSubject.value.isEmpty {
            return provider.requestPublisher(.fetchProfessionFields)
                .map(FieldResponseDTO.self)
                .map { [weak self] response -> [Field] in
                    let addableFields = response.data.professions.map { $0.toDomain() }
                    self?.addableFieldSubject.send(addableFields)
                    return addableFields
                }
                .catch { _ in Just([]) }
                .eraseToAnyPublisher()
        } else {
            return addableFieldSubject.eraseToAnyPublisher()
        }
    }

    func updateField(fields: [Field]) {
        fieldsSubject.send(fields)
    }
    
    func updateSearchedField(filteredFields: [Field]) {
        filteredFieldSubject.send(filteredFields)
    }
    
    func fetchSearchedField() -> AnyPublisher<[Field], Never> {
        return filteredFieldSubject.eraseToAnyPublisher()
    }
}
