//
//  SessionTokensDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/30.
//

import Foundation

struct SessionTokensDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isFirstLogin: Bool
}

extension SessionTokensDTO {
    func toDomain() -> SessionTokens {
        return .init(accessToken: accessToken,
                     refreshToken: refreshToken,
                     isFirstLogin: isFirstLogin)
    }
}
