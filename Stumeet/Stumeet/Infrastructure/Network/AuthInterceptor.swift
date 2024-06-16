//
//  AuthInterceptor.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Foundation
import Alamofire
import Combine

final class AuthInterceptor: RequestInterceptor {
    private let keychainManager: KeychainManageable
    private let useCase: TokenUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(keychainManager: KeychainManageable,
         useCase: TokenUseCase
    ) {
        self.keychainManager = keychainManager
        self.useCase = useCase
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401,
              let accessToken = keychainManager.getToken(for: .accessToken),
              let refreshToken = keychainManager.getToken(for: .refreshToken)
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        useCase
            .refreshToken(accessToken: accessToken, refreshToken: refreshToken)
            .sink { [weak self] success in
                if success {
                    completion(.retry)
                } else {
                    self?.logout()
                    completion(.doNotRetryWithError(error))
                }
            }
            .store(in: &cancellables)
    }
    
    // TODO: - 토큰 만료 플로우 및 로그아웃 처리 기획이 나오는대로 수정
    private func logout() {
        keychainManager.removeAllTokens()
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
}
