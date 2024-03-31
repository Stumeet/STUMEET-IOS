//
//  SessionTokensDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/30.
//

import Foundation


struct SessionTokensDTO: Decodable {
    var accessToken: String
    var refreshToken: String
    var isFirstLogin: Bool
}

extension SessionTokensDTO {
    func toDomain() -> SessionTokens {
        return .init(accessToken: accessToken,
                     refreshToken: refreshToken,
                     isFirstLogin: isFirstLogin)
    }
}
