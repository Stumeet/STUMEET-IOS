//
//  UserTokenRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Combine
import Moya

protocol UserTokenRepository {
    func updateAccessToken(accessToken: String, refreshToken: String) -> AnyPublisher<Bool, MoyaError>
}
