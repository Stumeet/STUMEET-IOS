//
//  AuthSceneDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/07.
//

import UIKit
import Moya

final class AuthSceneDIContainer: AuthCoordinatorDependencies {
    typealias Navigation = AuthNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
        let keychainManager: KeychainManageable
        let kakaoLoginService: LoginService
        let appleLoginService: LoginService
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases    
    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase.init(
            kakaoLoginService: dependencies.kakaoLoginService,
            appleLoginService: dependencies.appleLoginService,
            repository: makeSnsLoginRepository(),
            keychainManager: dependencies.keychainManager
        )
    }
    
    // MARK: - Repositories
    func makeSnsLoginRepository() -> LoginRepository {
        DefaultLoginRepository(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    // MARK: - Onboarding
    func makeOnboardingViewController(coordinator: Navigation) -> OnboardingViewController {
        OnboardingViewController.init(
            viewModel: makeOnboardingViewModel(),
            coordinator: coordinator
        )
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel.init()
    }
    
    // MARK: - Sns Login
    func makeSnsLoginViewController(coordinator: Navigation) -> SnsLoginViewController {
        SnsLoginViewController.init(
            viewModel: makeSnsLoginViewModel(),
            coordinator: coordinator
        )
    }
    
    func makeSnsLoginViewModel() -> SnsLoginViewModel {
        SnsLoginViewModel.init(
            useCase: makeLoginUseCase()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
