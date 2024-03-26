//
//  HomeCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol HomeNavigation: AnyObject {
    func goToHome()
}

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToHome()
    }
}

extension HomeCoordinator: HomeNavigation {
    func goToHome() {
        let homeVC = HomeViewController(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
}
