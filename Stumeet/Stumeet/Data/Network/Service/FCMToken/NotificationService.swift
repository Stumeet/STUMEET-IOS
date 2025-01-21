//
//  NotificationService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Moya

enum NotificationService {
    case updateFCMToken(FCMTokenRequestDTO)
    case fetchNotificationLogs(NotificationRequestDTO)
}

extension NotificationService: BaseTargetType {

    var path: String {
        switch self {
        case .updateFCMToken:
            return "/api/v1/notification-token/renew"
        case .fetchNotificationLogs:
            return "/api/v1/notification/logs"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchNotificationLogs:
            return .get
        case .updateFCMToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .updateFCMToken(let fcmTokenRequestDTO):
            guard let dto = fcmTokenRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: JSONEncoding.default)
        case .fetchNotificationLogs(let requestDTO):
            guard let dto = requestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
