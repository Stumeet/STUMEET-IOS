//
//  AuthToken.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Foundation

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
}