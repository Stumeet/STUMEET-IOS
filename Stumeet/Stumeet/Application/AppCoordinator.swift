//
//  AppCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit

final class AppCoordinator: CoordinatorTest {
    var parentCoordinator: CoordinatorTest?
    
    var children: [CoordinatorTest] = []
    
    var navigationController: UINavigationController
    
    func start() {
        makeAuthCoordinator()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func makeAuthCoordinator() {
        let onboardingCoordinator = AuthCoordinator(navigationController: navigationController)
        children.removeAll()
        onboardingCoordinator.parentCoordinator = self
        children.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
}
