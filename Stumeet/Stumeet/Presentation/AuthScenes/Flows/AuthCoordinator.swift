//
//  AuthCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit

final class AuthCoordinator: CoordinatorTest {
    var parentCoordinator: CoordinatorTest?
    var children: [CoordinatorTest] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToOnboarding()
    }
}

extension AuthCoordinator: AuthNavigation {
    func goToSnsLogin() {
        let registerVC = SnsLoginViewController(viewModel: SnsLoginViewModel(), coordinator: self)
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func goToOnboarding() {
        let onboardingVC = OnboardingViewController(viewModel: OnboardingViewModel(), coordinator: self)
        navigationController.pushViewController(onboardingVC, animated: true)
    }
}

protocol AuthNavigation: AnyObject {
    func goToSnsLogin()
    func goToOnboarding()
}
