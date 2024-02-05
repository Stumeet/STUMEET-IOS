//
//  StumeetApp.swift
//  Stumeet
//
//  Created by Hohyeon Moon on 2/5/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct StumeetApp: App {
    init() {
        KakaoSDK.initSDK(appKey: "NATIVE_APP_KEY")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
