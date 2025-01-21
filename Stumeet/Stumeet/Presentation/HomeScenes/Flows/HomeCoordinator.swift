//
//  HomeCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol HomeCoordinatorDependencies {
    func makeHomeVC(coordinator: HomeNavigation) -> HomeViewController
    func makeNotificationDIContainer() -> NotificationDIContainer
}

protocol HomeNavigation: AnyObject {
    func goToHome()
    func startNotificationCoordinator()
}

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: HomeCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: HomeCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        goToHome()
    }
}

extension HomeCoordinator: HomeNavigation {
    func goToHome() {
        let homeVC = dependencies.makeHomeVC(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func startNotificationCoordinator() {
        let homeNav = UINavigationController()
        let notificationDIContainer = dependencies.makeNotificationDIContainer()
        let flow = notificationDIContainer.makeNotificationCoordinator(
            navigationController: homeNav
        )
        
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start()
    }
}
