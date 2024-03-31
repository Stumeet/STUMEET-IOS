//
//  AuthService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/26.
//

import Moya

enum AuthService {
    case login
}

extension AuthService:
    BaseTargetType,
    AccessTokenAuthorizable {

    var path: String {
        switch self {
        case .login:
            return "/api/v1/oauth"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login:
            return .requestPlain
        }
    }
    
    // MARK: - AccessTokenAuthorizable
    var authorizationType: AuthorizationType? {
        switch self {
        case .login:
            return .bearer
        }
    }
}
