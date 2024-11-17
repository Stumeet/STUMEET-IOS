//
//  ScheduleCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import UIKit
import Moya

protocol ScheduleCoordinatorDependencies {
    func makeScheduleVC(coordinator: ScheduleNavigation, studyId: Int) -> ScheduleViewController
}

protocol ScheduleNavigation: AnyObject {
    func presentToScheduleVC(studyId: Int)
    func dimiss()
}

final class ScheduleCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: ScheduleCoordinatorDependencies
    private let studyId: Int

    init(
        navigationController: UINavigationController,
        dependencies: ScheduleCoordinatorDependencies,
        studyId: Int
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.studyId = studyId
    }
    
    func start() {
        presentToScheduleVC(studyId: studyId)
    }
    
    deinit {
        print("ScheduleCoordinator - 코디네이터 해제")
    }
}

extension ScheduleCoordinator: ScheduleNavigation {

    func presentToScheduleVC(studyId: Int) {
        let scheduleVC = dependencies.makeScheduleVC(
            coordinator: self,
            studyId: studyId
        )
        
        navigationController.setViewControllers([scheduleVC], animated: true)
        navigationController.presentationController?.delegate = scheduleVC

        parentCoordinator?.navigationController.presentedViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
