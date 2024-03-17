//
//  KakaoLoginService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Combine
import KakaoSDKAuth
import KakaoSDKUser
import Foundation

class KakaoLoginService: LoginService {
    
    func fetchAuthToken() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            // 카카오톡이 설치되어 있는지 확인합니다.
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    self.handleLoginResult(oauthToken: oauthToken, error: error, promise: promise)
                }
            } else {
                // 카카오톡으로 로그인할 수 없는 경우, 다른 방식(예: 웹 로그인)으로 진행합니다.
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    self.handleLoginResult(oauthToken: oauthToken, error: error, promise: promise)
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?, promise: @escaping (Result<Bool, Error>) -> Void) {
        if let error = error {
            promise(.failure(error))
        } else if let oauthToken = oauthToken {
            // 성공적으로 로그인하여 OAuth 토큰을 받았습니다.
            UserDefaults.standard.set(oauthToken.accessToken, forKey: "idToken")
            promise(.success(true))
        } else {
            // 예상치 못한 오류 처리
            promise(.failure(NSError(domain: "KakaoLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown login error"])))
        }
    }
}
