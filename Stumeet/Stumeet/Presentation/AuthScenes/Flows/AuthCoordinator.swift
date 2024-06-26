//
//  AuthCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit
import Moya

protocol AuthCoordinatorDependencies {
    func makeSnsLoginViewController(coordinator: AuthNavigation) -> SnsLoginViewController
    func makeOnboardingViewController(coordinator: AuthNavigation) -> OnboardingViewController
}

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
    private let dependencies: AuthCoordinatorDependencies

    init(navigationController: UINavigationController,
         dependencies: AuthCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        if UserDefaults.standard.bool(forKey: "SHOW_ONBOARDING_VC") {
            goToSnsLoginVC()
        } else {
            goToOnboardingVC()
        }
    }
    
    deinit {
        print("AuthCoordinator - 코디네이터 해제")
    }
}

extension AuthCoordinator: AuthNavigation {
    func goToSnsLoginVC() {
        let snsLoginVC = dependencies.makeSnsLoginViewController(coordinator: self)
        navigationController.pushViewController(snsLoginVC, animated: true)
        UserDefaults.standard.set(true, forKey: "SHOW_ONBOARDING_VC")
    }
    
    func goToOnboardingVC() {
        let onboardingVC = dependencies.makeOnboardingViewController(coordinator: self)
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
