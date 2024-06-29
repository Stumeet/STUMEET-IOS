//
//  NetworkServiceProvider.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/26.
//

import Moya

final class NetworkServiceProvider {
    private let keychainManager: KeychainManageable
    private let interceptor: RequestInterceptor?
    private let accessTokenPlugin: AccessTokenPlugin
    private let networkLoggerPlugin: NetworkLoggerPlugin

    init(keychainManager: KeychainManageable,
         interceptor: RequestInterceptor? = nil,
         networkLoggerPlugin: NetworkLoggerPlugin
    ) {
        self.keychainManager = keychainManager
        self.interceptor = interceptor
        self.networkLoggerPlugin = networkLoggerPlugin
        self.accessTokenPlugin = AccessTokenPlugin { _ in
            guard let token = keychainManager.getToken(for: .accessToken) else {
                // TODO: 적절한 에러 처리 필요함
                fatalError("AccessToken is missing")
            }
            return token
        }
    }

    func makeProvider<Target: TargetType>() -> MoyaProvider<Target> {
        guard let interceptor = interceptor else {
            return MoyaProvider<Target>(plugins: [networkLoggerPlugin])
        }
        
        if Target.self as? AuthService.Type != nil {
            return MoyaProvider<Target>(session: Session(interceptor: interceptor),
                                        plugins: [networkLoggerPlugin])
        } else {
            return MoyaProvider<Target>(session: Session(interceptor: interceptor),
                                        plugins: [networkLoggerPlugin, accessTokenPlugin])
        }
    }
}
