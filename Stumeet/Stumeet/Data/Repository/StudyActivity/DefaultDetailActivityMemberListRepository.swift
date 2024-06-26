//
//  DefaultDetailActivityMemberListRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

final class MockDetailActivityMemberListRepository: DetailActivityMemberListRepository {
    
    let members = [
        DetailActivityMember(name: "홍길동1", state: "미수행"),
        DetailActivityMember(name: "홍길동2", state: "수행"),
        DetailActivityMember(name: "홍길동3", state: "수행"),
        DetailActivityMember(name: "홍길동4", state: "수행"),
        DetailActivityMember(name: "홍길동5", state: "미수행")
    ]
    
    func fetchMembers() -> AnyPublisher<[DetailActivityMember], Never> {
        return Just(members).eraseToAnyPublisher()
    }
}
