//
//  ActivityMemberSettingUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 5/17/24.
//

import Combine
import Foundation

protocol ActivityMemberSettingUseCase {
    func getMembers() -> AnyPublisher<[String], Never>
}

final class DefaultActivityMemberSettingUseCase: ActivityMemberSettingUseCase {
    private let repository: ActivityMemberSettingRepository
    
    init(repository: ActivityMemberSettingRepository) {
        self.repository = repository
    }
    
    func getMembers() -> AnyPublisher<[String], Never> {
        return repository.fetchMembers()
    }
    
}
