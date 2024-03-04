//
//  SelecteFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

import Moya

protocol SelecteFieldRepository {
    func getFields() -> AnyPublisher<[Field], Never>
    func fetchAddableFields() -> AnyPublisher<[Field], Never>
    func updateField(fields: [Field])
    func updateSearchedField(filteredFields: [Field])
    func fetchSearchedField() -> AnyPublisher<[Field], Never>
}
