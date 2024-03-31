//
//  APIConst.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Foundation

struct APIConst {
    static let accessToken = "ACCESS_TOKEN"
    static let refreshToken = "REFRESH_TOKEN"
    static let loginType = "LOGIN_TYPE"
    static let loginSnsToken = "LOGIN_SNS_TOKEN"
    
    static func getLoginType() -> String {
        if let token = UserDefaults.standard.value(forKey: APIConst.loginType) as? String {
            print("LOGIN_TYPE \(token)")
            return token
        }
        return ""
    }
    
    // TODO: - 임시 코드 삭제 예정
    static func getToken() -> String {
        if let token = UserDefaults.standard.value(forKey: APIConst.accessToken) as? String {
            print("accessToken \(token)")
            return token
        }
        return ""
    }
}
