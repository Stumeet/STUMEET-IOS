//
//  OauthResponseDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/30.
//

import Foundation

struct OauthResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isFirstLogin: Bool
}

extension OauthResponseDTO {
    func toDomain() -> UserAuthInfo {
        return .init(
            authTokens: AuthToken(
                accessToken: accessToken,
                refreshToken: refreshToken
            ),
            isFirstLogin: isFirstLogin
        )
    }
}
