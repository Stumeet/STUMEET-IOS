//
//  AuthCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit
import Moya

final class AuthCoordinator: CoordinatorTest {
    var parentCoordinator: CoordinatorTest?
    var children: [CoordinatorTest] = []
    var navigationController: UINavigationController
    
    private let accessTokenPlugin = AccessTokenPlugin { _ in
        // TODO: nil인경우 재발급 등 추가 로직 필요
        KeychainManager.shared.getToken(for: PrototypeAPIConst.loginSnsToken) ?? ""
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToOnboarding()
    }
}

extension AuthCoordinator: AuthNavigation {
    func goToSnsLogin() {
        let repository = DefaultLoginRepository(provider: MoyaProvider<PrototypeAPIService>(plugins: [accessTokenPlugin]))
        let viewModel = SnsLoginViewModel(repository: repository)
        let registerVC = SnsLoginViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func goToOnboarding() {
        let viewModel = OnboardingViewModel()
        let onboardingVC = OnboardingViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(onboardingVC, animated: true)
    }
}

protocol AuthNavigation: AnyObject {
    func goToSnsLogin()
    func goToOnboarding()
}
