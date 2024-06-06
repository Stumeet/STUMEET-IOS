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
        // TODO: - 현재는 401코드의 경우 토큰 재발급 처리가 이루어 지고있지만, 토큰 만료 케이스의 특정 코드를 정할 필요가 있음, 현재 API는 토큰 만료 이외에도 401케이스가 있기에 무한 재발급될 우려가 있음
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
            .sink { success in
                if success {
                    completion(.retry)
                } else {
                    completion(.doNotRetryWithError(error))
                }
            }
            .store(in: &cancellables)
    }
}
