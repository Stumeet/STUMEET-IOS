//
//  FCMTokenService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Moya

enum FCMTokenService {
    case updateFCMToken(FCMTokenRequestDTO)
}

extension FCMTokenService: BaseTargetType {

    var path: String {
        switch self {
        case .updateFCMToken:
            return "/api/v1/notification-token/renew"
        }
    }
    
    var method: Method {
        switch self {
        case .updateFCMToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .updateFCMToken(let fcmTokenRequestDTO):
            guard let dto = fcmTokenRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
