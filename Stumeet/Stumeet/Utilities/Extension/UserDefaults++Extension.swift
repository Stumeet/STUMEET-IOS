//
//  UserDefaults++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/06/30.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let fcmToken = "FCMTokenKey"
    }
    
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
        }
        return isFirstLaunch
    }
        
    func setFCMToken(_ token: String) {
        set(token, forKey: Keys.fcmToken)
    }
    
    func getFCMToken() -> String? {
        return string(forKey: Keys.fcmToken)
    }
}
