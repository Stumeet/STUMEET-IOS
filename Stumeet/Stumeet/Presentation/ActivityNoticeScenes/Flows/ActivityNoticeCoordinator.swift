//
//  ActivityNoticeCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import UIKit
import Moya

protocol ActivityNoticeCoordinatorDependencies {
    func makeActivityNoticeVC(coordinator: ActivityNoticeNavigation, studyId: Int) -> ActivityNoticeViewController
}

protocol ActivityNoticeNavigation: AnyObject {
    func presentToNoticeVC(studyId: Int)
    func dimiss()
}

final class ActivityNoticeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: ActivityNoticeCoordinatorDependencies
    private let studyId: Int

    init(
        navigationController: UINavigationController,
        dependencies: ActivityNoticeCoordinatorDependencies,
        studyId: Int
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.studyId = studyId
    }
    
    func start() {
        presentToNoticeVC(studyId: studyId)
    }
    
    deinit {
        print("ActivityNoticeCoordinator - 코디네이터 해제")
    }
}

extension ActivityNoticeCoordinator: ActivityNoticeNavigation {

    func presentToNoticeVC(studyId: Int) {
        let noticeVC = dependencies.makeActivityNoticeVC(
            coordinator: self,
            studyId: studyId
        )
        
        navigationController.setViewControllers([noticeVC], animated: true)
        navigationController.presentationController?.delegate = noticeVC

        parentCoordinator?.navigationController.presentedViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
