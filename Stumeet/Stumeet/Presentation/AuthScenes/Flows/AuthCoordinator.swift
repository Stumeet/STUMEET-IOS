//
//  AuthCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit
import Moya

protocol AuthNavigation: AnyObject {
    func goToSnsLoginVC()
    func goToOnboardingVC()
    func goToHomeVC()
    func goToRegisterVC()
}

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToOnboardingVC()
    }
    
    deinit {
        print("AuthCoordinator - 코디네이터 해제")
    }
}

extension AuthCoordinator: AuthNavigation {
    func goToSnsLoginVC() {
        let keychainManager = KeychainManager()
        let networkServiceProvider = NetworkServiceProvider(keychainManager: keychainManager)
        let repository = DefaultLoginRepository(provider: networkServiceProvider.makeProvider())
        let viewModel = SnsLoginViewModel(repository: repository, keychainManager: keychainManager)
        let registerVC = SnsLoginViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func goToOnboardingVC() {
        let viewModel = OnboardingViewModel()
        let onboardingVC = OnboardingViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(onboardingVC, animated: true)
    }

    func goToHomeVC() {
        let appCoordinator = parentCoordinator as! AppCoordinator
        appCoordinator.startTabbarCoordinator()
        appCoordinator.childDidFinish(self)
    }
    
    func goToRegisterVC() {
        let appCoordinator = parentCoordinator as! AppCoordinator
        appCoordinator.startRegisterCoordinator()
        appCoordinator.childDidFinish(self)
    }
}
