//
//  AppConfigurations.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import Foundation

enum AppConfiguration {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let apiBaseURL = "ApiBaseURL"
            static let kakaoNativeAppKey = "kakaoNativeAppKey"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let getApiBaseURL: String = {
        guard let url = infoDictionary[Keys.Plist.apiBaseURL] as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return url
    }()
    
    static let getKakaoNativeAppKey: String = {
        guard let key = infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("kakaoNativeAppKey must not be empty in plist")
        }
        return key
    }()
}
