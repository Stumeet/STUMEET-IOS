//
//  PrototypeAPIService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Moya
import Foundation


enum PrototypeAPIService {
    case login
}

extension PrototypeAPIService: TargetType {
    var baseURL: URL { return URL(string: AppConfiguration.getApiBaseURL)! }

    var path: String {
        switch self {
        case .login:
            return "/api/v1/oauth"
        }
    }
    
    var method: Moya.Method {
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
        switch self {
        case .login:
            return ["Authorization": "Bearer \(PrototypeAPIConst.getSnsToken())",
                    "X-OAUTH-PROVIDER": "\(PrototypeAPIConst.getLoginType())",
                    "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
}
