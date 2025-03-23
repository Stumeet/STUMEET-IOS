//
//  UserRepository.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Combine
import Moya

protocol UserRepository {
    func fetchMyProfile() -> AnyPublisher<UserProfile, MoyaError>
}
