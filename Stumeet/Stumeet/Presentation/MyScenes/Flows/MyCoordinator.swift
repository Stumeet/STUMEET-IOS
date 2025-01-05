//
//  MyCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import UIKit

protocol MyCoordinatorDependencies {
    func makeMyVC(coordinator: MyNavigation) -> MyViewController
}

protocol MyNavigation: AnyObject {
    func goToMy()
}

final class MyCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: MyCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: MyCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        goToMy()
    }
}

extension MyCoordinator: MyNavigation {
    func goToMy() {
        let homeVC = dependencies.makeMyVC(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
}
