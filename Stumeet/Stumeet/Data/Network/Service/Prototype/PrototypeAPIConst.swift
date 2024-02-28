//
//  PrototypeAPIConst.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Foundation

struct PrototypeAPIConst {
    static let accessToken = "ACCESS_TOKEN"
    static let refreshToken = "REFRESH_TOKEN"
    static let loginType = "LOGIN_TYPE"
    static let loginSnsToken = "LOGIN_SNS_TOKEN"

    
    static func getToken() -> String {
        if let token = UserDefaults.standard.value(forKey: PrototypeAPIConst.accessToken) as? String {
            print("ACCESS_TOKEN \(token)")
            return token
        }
        return "토큰 어디있게"
    }
    
    static func getSnsToken() -> String {
        if let token = UserDefaults.standard.value(forKey: PrototypeAPIConst.loginSnsToken) as? String {
            print("LOGIN_SNS_TOKEN \(token)")
            return token
        }
        return "토큰 어디있게"
    }
    
    static func getLoginType() -> String {
        if let token = UserDefaults.standard.value(forKey: PrototypeAPIConst.loginType) as? String {
            print("LOGIN_TYPE \(token)")
            return token
        }
        return "타입 어디있으까"
    }
    
    static func getRefreshToken() -> String {
        if let token = UserDefaults.standard.value(forKey: PrototypeAPIConst.refreshToken) as? String {
            print("REFRESH_TOKEN \(token)")
            return token
        }
        return "맞춰봐라"
    }
}
