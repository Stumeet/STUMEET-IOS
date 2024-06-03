//
//  DetailActivityMemberListUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

protocol DetailActivityMemberListUseCase {
    func setMembers() -> AnyPublisher<[DetailActivityMemberSectionItem], Never>
    func setMemberCount(members: [DetailActivityMemberSectionItem]) -> AnyPublisher<String?, Never>
}

final class DefualtDetailActivityMemberListUseCase: DetailActivityMemberListUseCase {
    
    private let repository: DetailActivityMemberListRepository
    
    init(repository: DetailActivityMemberListRepository) {
        self.repository = repository
    }
    
    func setMembers() -> AnyPublisher<[DetailActivityMemberSectionItem], Never> {
        return repository.fetchMembers()
            .map { $0.map { .memberCell($0) } }
            .eraseToAnyPublisher()
    }
    
    func setMemberCount(members: [DetailActivityMemberSectionItem]) -> AnyPublisher<String?, Never> {
        return Just(String(members.count)).eraseToAnyPublisher()
    }
}