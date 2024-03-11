//
//  PrototypeLoginManager.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Foundation

class PrototypeLoginManager {
    public static let shared = PrototypeLoginManager()

    func login(_ completion: @escaping (PrototypeOauth?) -> ()) {
        PrototypeAPIManager.shared.login() { [weak self] data in
            guard let self = self else { return }
            let oauthInfo = data?.data
            UserDefaults.standard.setValue(oauthInfo?.accessToken, forKey: PrototypeAPIConst.accessToken)
            UserDefaults.standard.setValue(oauthInfo?.refreshToken, forKey: PrototypeAPIConst.refreshToken)
            printLoginInfo()
            completion(data?.data)
        }
    }
    
    func printLoginInfo() {
        print("loginType : \(UserDefaults.standard.value(forKey: PrototypeAPIConst.loginType) ?? "")")
        print("accessToken : \(UserDefaults.standard.value(forKey: PrototypeAPIConst.accessToken) ?? "")")
        print("refreshToken : \(UserDefaults.standard.value(forKey: PrototypeAPIConst.refreshToken) ?? "")")
        print("loginSnsToken : \(UserDefaults.standard.value(forKey: PrototypeAPIConst.loginSnsToken) ?? "")")
    }
    
    private init() { }
}
