//
//  AppCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []    
    var navigationController: UINavigationController
    
    func start() {
        startAuthCoordinator()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startAuthCoordinator() {
        let onboardingCoordinator = AuthCoordinator(navigationController: navigationController)
        children.removeAll()
        onboardingCoordinator.parentCoordinator = self
        children.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func startRegisterCoordinator() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        children.removeAll()
        registerCoordinator.parentCoordinator = self
        children.append(registerCoordinator)
        registerCoordinator.start()
    }
    
    func startTabbarCoordinator() {
        let tabbarCoordinator = TabBarCoordinator(navigationController: navigationController)
        children.removeAll()
        tabbarCoordinator.parentCoordinator = self
        tabbarCoordinator.start()
    }
    
}
