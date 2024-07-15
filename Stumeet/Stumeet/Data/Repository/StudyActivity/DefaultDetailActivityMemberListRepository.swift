//
//  DefaultDetailActivityMemberListRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class MockDetailActivityMemberListRepository: DetailActivityMemberListRepository {
    
    private let provider: MoyaProvider<ActivityService>
    
    init(provider: MoyaProvider<ActivityService>) {
        self.provider = provider
    }
    
    func fetchMembers() -> AnyPublisher<[DetailActivityMember], Never> {
        return Just(members).eraseToAnyPublisher()
    }
}
