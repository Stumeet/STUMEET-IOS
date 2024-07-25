//
//  CreateStudyGroupCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 7/24/24.
//

import UIKit

protocol CreateStudyGroupCoordinatorDependencies {
    func makeCreateStudyGroupVC(coordinator: CreateStudyGroupNavigation) -> CreateStudyGroupViewController
    func makeSelectStudyGroupFieldVC(coordinator: CreateStudyGroupNavigation) -> SelectStudyGroupFieldViewController
}

protocol CreateStudyGroupNavigation: AnyObject {
    func presentToCreateStudyGroupVC()
    func navigateToSelectStudyGroupFieldVC()
}

final class CreateStudyGroupCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: CreateStudyGroupCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: CreateStudyGroupCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentToCreateStudyGroupVC()
    }
}

extension CreateStudyGroupCoordinator: CreateStudyGroupNavigation {
    func presentToCreateStudyGroupVC() {
        let createActivityVC = dependencies.makeCreateStudyGroupVC(coordinator: self)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.viewControllers.append(createActivityVC)
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func navigateToSelectStudyGroupFieldVC() {
        let fieldVC = dependencies.makeSelectStudyGroupFieldVC(coordinator: self)
        navigationController.pushViewController(fieldVC, animated: true)
    }
}
