//
//  DetailActivityMemberListUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

protocol DetailActivityMemberListUseCase {
    func getMembers() -> AnyPublisher<[DetailActivityMemberSectionItem], Never>
    func getMemberCount(members: [DetailActivityMemberSectionItem]) -> AnyPublisher<String?, Never>
}

final class DefualtDetailActivityMemberListUseCase: DetailActivityMemberListUseCase {
    
    private let repository: DetailActivityMemberListRepository
    
    init(repository: DetailActivityMemberListRepository) {
        self.repository = repository
    }
    
    func getMembers() -> AnyPublisher<[DetailActivityMemberSectionItem], Never> {
        return repository.fetchMembers()
            .map { $0.map { .memberCell($0) } }
            .eraseToAnyPublisher()
    }
    
    func getMemberCount(members: [DetailActivityMemberSectionItem]) -> AnyPublisher<String?, Never> {
        return Just(String(members.count)).eraseToAnyPublisher()
    }
}
