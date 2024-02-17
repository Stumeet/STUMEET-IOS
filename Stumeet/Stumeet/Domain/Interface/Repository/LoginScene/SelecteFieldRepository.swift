//
//  SelecteFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

protocol SelecteFieldRepository {
    func getFields() -> AnyPublisher<[Field], Never>
    func selectField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never>
    func getSearchedField(text: String) -> AnyPublisher<[AddableField], Never>
    func addField(at indexPath: IndexPath) -> AnyPublisher<[Field], Never>
}
