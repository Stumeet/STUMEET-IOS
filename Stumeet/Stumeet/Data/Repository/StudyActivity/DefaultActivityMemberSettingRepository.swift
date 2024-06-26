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
    
    private let members: [ActivityMember] = [
        ActivityMember(id: 1, imageURL: nil, name: "홍길1", isSelected: false),
        ActivityMember(id: 2, imageURL: nil, name: "홍길2", isSelected: false),
        ActivityMember(id: 3, imageURL: nil, name: "홍길3", isSelected: false),
        ActivityMember(id: 4, imageURL: nil, name: "홍길4", isSelected: false),
        ActivityMember(id: 5, imageURL: nil, name: "김개1", isSelected: false),
        ActivityMember(id: 6, imageURL: nil, name: "김개2", isSelected: false),
        ActivityMember(id: 7, imageURL: nil, name: "김개3", isSelected: false),
        ActivityMember(id: 8, imageURL: nil, name: "김개4", isSelected: false),
    ]
    
    func fetchMembers() -> AnyPublisher<[ActivityMember], Never> {
        return Just(members).eraseToAnyPublisher()
    }
    
}



