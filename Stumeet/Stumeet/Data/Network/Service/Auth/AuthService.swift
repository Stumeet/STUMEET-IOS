//
//  AuthService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/26.
//

import Moya

enum AuthService {
    case login(LoginType, String)
    case fetchMyProfile
}

extension AuthService: BaseTargetType {

    var path: String {
        switch self {
        case .login:
            return "/api/v1/oauth"
        case .fetchMyProfile:
            return "/api/v1/members/me"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        case .fetchMyProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login, .fetchMyProfile:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login(let loginType, let snsToken):
            guard let authorizationType = authorizationType
            else { return [:] }
            
            let authValue = authorizationType.value + " " + snsToken
            return ["Authorization": authValue,
                    "X-OAUTH-PROVIDER": loginType.english,
                    "Content-Type": "application/x-www-form-urlencoded"]
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}
