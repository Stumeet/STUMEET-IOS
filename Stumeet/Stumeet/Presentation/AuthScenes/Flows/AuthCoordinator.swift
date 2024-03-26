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
    
    private let accessTokenPlugin = AccessTokenPlugin { _ in
        // TODO: nil인경우 재발급 등 추가 로직 필요
        KeychainManager.shared.getToken(for: PrototypeAPIConst.loginSnsToken) ?? ""
    }
    
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
        let repository = DefaultLoginRepository(provider: MoyaProvider<PrototypeAPIService>(plugins: [accessTokenPlugin]))
        let viewModel = SnsLoginViewModel(repository: repository)
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
