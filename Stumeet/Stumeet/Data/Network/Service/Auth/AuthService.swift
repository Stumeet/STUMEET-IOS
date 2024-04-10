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

extension AuthService: BaseTargetType {

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
    
    var headers: [String: String]? {
        return ["X-OAUTH-PROVIDER": APIConst.getLoginType(),
                "Content-Type": "application/x-www-form-urlencoded"]
    }
}
