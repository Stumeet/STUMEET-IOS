//
//  StudyListCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol StudyListCoordinatorDependencies {
    func makeStudyListVC(coordinator: StudyListNavigation) -> StudyListViewController
    func makeStudyActivityListVC(coordinator: StudyListNavigation) -> StudyActivityListViewController
}

protocol StudyListNavigation: AnyObject {
    func goToStudyList()
    func goToStudyActivityList()
    func startCreateActivityCoordinator()
}

final class StudyListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: StudyListCoordinatorDependencies
    private let appDIConatiner: AppDIContainer
    
    init(navigationController: UINavigationController,
         dependencies: StudyListCoordinatorDependencies,
         diContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.appDIConatiner = diContainer
    }
    
    func start() {
        goToStudyList()
    }
}

extension StudyListCoordinator: StudyListNavigation {
    
    func goToStudyList() {
        let studyListVC = dependencies.makeStudyListVC(coordinator: self)
        navigationController.pushViewController(studyListVC, animated: true)
    }
    
    func goToStudyActivityList() {
        let studyActivityListVC = dependencies.makeStudyActivityListVC(coordinator: self)
        studyActivityListVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(studyActivityListVC, animated: true)
    }
    
    func startCreateActivityCoordinator() {
        let createActivityDIContainer = appDIConatiner.makeCreateActivityListSceneDIContainer()
        let createActivityNVC = UINavigationController()
        let flow = createActivityDIContainer.makeCreateActivityCoordinator(navigationController: createActivityNVC)
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start()
    }
}
