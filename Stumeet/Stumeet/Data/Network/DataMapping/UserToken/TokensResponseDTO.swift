//
//  TokensResponseDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Foundation

struct TokensResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension TokensResponseDTO {
    func toDomain() -> AuthToken {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
