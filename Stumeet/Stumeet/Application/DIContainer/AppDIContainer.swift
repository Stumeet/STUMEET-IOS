//
//  AppDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/07.
//

import Foundation
import Moya


final class AppDIContainer {
    lazy var keychainManager: KeychainManageable = KeychainManager()
    
    // MARK: - Network
    lazy var authInterceptor: RequestInterceptor = {
        AuthInterceptor(keychainManager: keychainManager,
                        useCase: DefaultTokenUseCase(
                            repository: DefaultUserTokenRepository(
                                provider: NetworkServiceProvider(
                                    keychainManager: keychainManager,
                                    isAccessTokenPlugin: false,
                                    pluginTypes: [NetworkLoggerPlugin()]
                                ).makeProvider(),
                                keychainManager: keychainManager
                            )
                        )
        )
    }()
    
    lazy var networkServiceProvider: NetworkServiceProvider = {
        NetworkServiceProvider(keychainManager: keychainManager,
                               interceptor: authInterceptor,
                               pluginTypes: [NetworkLoggerPlugin()]
        )
    }()
    
    // MARK: - DIContainers of scenes
    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(
            provider: networkServiceProvider,
            keychainManager: keychainManager
        )
        return AuthSceneDIContainer(dependencies: dependencies)
    }
    
    func makeRegisterSceneDIContainer() -> RegisterSceneDIContainer {
        let dependencies = RegisterSceneDIContainer.Dependencies(
            provider: networkServiceProvider
        )
        return RegisterSceneDIContainer(dependencies: dependencies)
    }
}
