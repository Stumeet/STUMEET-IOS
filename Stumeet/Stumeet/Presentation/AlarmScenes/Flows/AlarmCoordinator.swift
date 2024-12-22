//
//  AlarmCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import UIKit

protocol AlarmCoordinatorDependencies {
    func makeAlarmVC(coordinator: AlarmNavigation) -> AlarmViewController
}

protocol AlarmNavigation: AnyObject {
    func presentToAlarmVC()
    func dimiss()
}

final class AlarmCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: AlarmCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: AlarmCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentToAlarmVC()
    }
}

extension AlarmCoordinator: AlarmNavigation {
    func presentToAlarmVC() {
        let alarmVC = dependencies.makeAlarmVC(
            coordinator: self
        )
        
        navigationController.setViewControllers([alarmVC], animated: true)
        navigationController.modalPresentationStyle = .overFullScreen
        parentCoordinator?.presentOnTop(navigationController)
    }

    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
