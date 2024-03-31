//
//  NetworkServiceProvider.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/26.
//

import Moya

class NetworkServiceProvider {
    private let accessTokenPlugin: AccessTokenPlugin
    private let loggerPlugin: NetworkLoggerPlugin
    private let keychainManager: KeychainManageable

    init(keychainManager: KeychainManageable) {
        self.keychainManager = keychainManager
        self.accessTokenPlugin = AccessTokenPlugin { _ in
            // TODO: - 키체인 에러 케이스 로직 필요
            keychainManager.getToken(for: APIConst.loginSnsToken) ?? ""
        }
        self.loggerPlugin = NetworkLoggerPlugin()
    }

    func makeProvider<Target: TargetType>() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(plugins: [accessTokenPlugin, loggerPlugin])
    }
}
