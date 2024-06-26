//
//  AuthTokenDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Foundation

struct AuthTokenDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension AuthTokenDTO {
    func toDomain() -> AuthToken {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
