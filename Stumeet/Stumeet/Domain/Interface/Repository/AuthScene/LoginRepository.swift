//
//  LoginRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/30.
//

import Foundation
import Combine
import Moya

protocol LoginRepository {
    func requestLogin() -> AnyPublisher<SessionTokens, MoyaError>
}
