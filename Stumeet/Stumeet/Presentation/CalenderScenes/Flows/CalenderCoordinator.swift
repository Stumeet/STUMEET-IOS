//
//  CalenderCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/19.
//

import UIKit

protocol CalenderCoordinatorDependencies {
    func makeCalenderVC(coordinator: CalenderNavigation) -> CalenderViewController
}

protocol CalenderNavigation: AnyObject {
    func goToCalender()
}

final class CalenderCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: CalenderCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: CalenderCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        goToCalender()
    }
}

extension CalenderCoordinator: CalenderNavigation {
    func goToCalender() {
        let calenderVC = dependencies.makeCalenderVC(coordinator: self)
        navigationController.pushViewController(calenderVC, animated: true)
    }
}
