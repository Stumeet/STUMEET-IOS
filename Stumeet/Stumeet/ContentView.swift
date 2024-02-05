//
//  ContentView.swift
//  Stumeet
//
//  Created by Hohyeon Moon on 2/5/24.
//

import SwiftUI
import KakaoSDKUser

struct ContentView: View {
    var body: some View {
        Button("Kakao login") {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error {
                        print(error)
                    } else {
                        print("loginWithKakaoTalk() success.")
                        _ = oauthToken
                    }
                }
            }
        }
    }
}
