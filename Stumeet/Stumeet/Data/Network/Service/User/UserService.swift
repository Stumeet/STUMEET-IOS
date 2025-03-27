//
//  UserService.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/27/25.
//

import Moya

enum UserService {
    case fetchMyProfile
}

extension UserService: BaseTargetType {

    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/api/v1/members/me"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchMyProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMyProfile:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}

