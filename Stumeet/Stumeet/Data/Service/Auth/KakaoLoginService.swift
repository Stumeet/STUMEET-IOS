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
    func fetchAuthToken() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: { (oauthToken, error) in
                    self.handleLoginResult(oauthToken: oauthToken, error: error, promise: promise)
                })
            } else {
                // 카카오톡 없는 경우, 다른 방식(예: 웹 로그인)으로 진행
                UserApi.shared.loginWithKakaoAccount(completion: { (oauthToken, error) in
                    self.handleLoginResult(oauthToken: oauthToken, error: error, promise: promise)
                })
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?, promise: @escaping (Result<String, Error>) -> Void) {
        if let error = error {
            promise(.failure(error))
        } else if let oauthToken = oauthToken {
            
            // TODO: 임시코드 삭제 예정
            UserDefaults.standard.setValue(oauthToken.accessToken, forKey: APIConst.accessToken)
            
            promise(.success(oauthToken.accessToken))
        } else {
            promise(.failure(NSError(domain: "KakaoLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown login error"])))
        }
    }
}
