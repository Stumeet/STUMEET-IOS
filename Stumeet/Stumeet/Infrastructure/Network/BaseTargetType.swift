//
//  BaseTargetType.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/30.
//

import UIKit
import Moya

protocol BaseTargetType: TargetType {
    var baseURL: URL {get}
    var path: String {get}
    var method: Moya.Method {get}
    var task: Task {get}
    var headers: [String: String]? {get}
}

extension BaseTargetType {
    var baseURL: URL { return URL(string: AppConfiguration.getApiBaseURL)! }
    var headers: [String: String]? {
        return ["X-OAUTH-PROVIDER": APIConst.getLoginType(),
                "Content-Type": "application/x-www-form-urlencoded"]
    }
}
