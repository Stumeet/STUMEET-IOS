//
//  AccessTokenDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Foundation

struct AccessTokenDTO: Decodable {
    let accessToken: String
}

extension AccessTokenDTO {
    func toDomain() -> AccessToken {
        return .init(accessToken: accessToken)
    }
}
