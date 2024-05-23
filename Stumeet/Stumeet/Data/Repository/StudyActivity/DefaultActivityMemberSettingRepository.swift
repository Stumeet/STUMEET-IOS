//
//  DefaultActivityMemberSettingRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/17/24.
//

import Combine
import Foundation

final class DefaultActivityMemberSettingRepository: ActivityMemberSettingRepository {
    
    // TODO: - Networking
    
    private let members: [String] = ["홍길동1", "홍길동2", "홍길동3", "홍길동4","홍길동5","홍길동6", "홍길동7", "홍길동8", "홍길동9"]
    
    func fetchMembers() -> AnyPublisher<[String], Never> {
        return Just(members).eraseToAnyPublisher()
    }
    
}



