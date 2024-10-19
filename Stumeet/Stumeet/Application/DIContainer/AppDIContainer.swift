//
//  AppDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/07.
//

import Foundation
import Moya


final class AppDIContainer {
    let keychainManager: KeychainManageable = KeychainManager()
    
    // MARK: - Sns Login
    let kakaoLoginService: LoginService = KakaoLoginService()
    let appleLoginService: LoginService = AppleLoginService()
    
    // MARK: - Network
    lazy var authInterceptor: RequestInterceptor = {
        AuthInterceptor(keychainManager: keychainManager,
                        useCase: DefaultTokenUseCase(
                            repository: DefaultUserTokenRepository(
                                provider: NetworkServiceProvider(
                                    keychainManager: keychainManager,
                                    networkLoggerPlugin: NetworkLoggerPlugin()
                                ).makeProvider(),
                                keychainManager: keychainManager
                            )
                        )
        )
    }()
    
    lazy var networkServiceProvider: NetworkServiceProvider = {
        NetworkServiceProvider(keychainManager: keychainManager,
                               interceptor: authInterceptor,
                               networkLoggerPlugin: NetworkLoggerPlugin()
        )
    }()
    
    // MARK: - FCMToken
    lazy var fcmTokenManager: FCMTokenManager = {
        FCMTokenManager(repository: DefaultFCMTokenRepository(provider: networkServiceProvider.makeProvider()))
    }()

    // MARK: - DIContainers of scenes
    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(
            provider: networkServiceProvider,
            keychainManager: keychainManager,
            kakaoLoginService: kakaoLoginService,
            appleLoginService: appleLoginService
        )
        return AuthSceneDIContainer(dependencies: dependencies)
    }
    
    func makeMyStudyGroupListDIContainer() -> MyStudyGroupListDIContainer {
        let dependencies = MyStudyGroupListDIContainer.Dependencies(
            provider: networkServiceProvider
        )
        return MyStudyGroupListDIContainer(dependencies: dependencies)
    }
}
