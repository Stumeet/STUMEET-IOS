//
//  NotificationCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import UIKit

protocol NotificationCoordinatorDependencies {
    func makeNotificationVC(coordinator: NotificationNavigation) -> NotificationViewController
}

protocol NotificationNavigation: AnyObject {
    func presentToAlarmVC()
    func dimiss()
}

final class NotificationCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: NotificationCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: NotificationCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentToAlarmVC()
    }
}

extension NotificationCoordinator: NotificationNavigation {
    func presentToAlarmVC() {
        let notificationVC = dependencies.makeNotificationVC(
            coordinator: self
        )
        
        navigationController.setViewControllers([notificationVC], animated: true)
        navigationController.modalPresentationStyle = .overFullScreen
        parentCoordinator?.presentOnTop(navigationController)
    }

    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
