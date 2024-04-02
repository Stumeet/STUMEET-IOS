//
//  NetworkServiceProvider.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/26.
//

import Moya

final class NetworkServiceProvider {
    private var pluginTypes: [PluginType]
    private let keychainManager: KeychainManageable
    private let interceptor: RequestInterceptor?

    init(keychainManager: KeychainManageable,
         isAccessTokenPlugin: Bool = true,
         interceptor: RequestInterceptor? = nil,
         pluginTypes: [PluginType] = []
    ) {
        self.keychainManager = keychainManager
        self.interceptor = interceptor
        self.pluginTypes = pluginTypes
        
        guard isAccessTokenPlugin else { return }
        // TODO: - 키체인 에러 케이스 로직 필요
        self.pluginTypes.append(AccessTokenPlugin { _ in keychainManager.getToken(for: APIConst.loginSnsToken) ?? "" })
    }

    func makeProvider<Target: TargetType>() -> MoyaProvider<Target> {
        guard let interceptor = interceptor else {
            return MoyaProvider<Target>(plugins: pluginTypes)
        }
        
        return MoyaProvider<Target>(session: Session(interceptor: interceptor),
                                    plugins: pluginTypes)
    }
}
