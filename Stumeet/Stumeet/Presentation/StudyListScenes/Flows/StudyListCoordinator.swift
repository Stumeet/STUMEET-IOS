//
//  StudyListCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol StudyListNavigation: AnyObject {
    func goToStudyList()
}

final class StudyListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToStudyList()
    }
}

extension StudyListCoordinator: StudyListNavigation {
    func goToStudyList() {
        let studyListVC = StudyListViewController(coordinator: self)
        navigationController.pushViewController(studyListVC, animated: true)
    }
}
