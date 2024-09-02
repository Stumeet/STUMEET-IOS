//
//  StudyMemberCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/27.
//

import UIKit
import PhotosUI
import Moya

protocol StudyMemberCoordinatorDependencies {
    func makeStudyMemberVC(coordinator: StudyMemberNavigation, studyId: Int) -> StudyMemberViewController
    func makeStudyMemberDetailVC(coordinator: StudyMemberNavigation) -> StudyMemberDetailViewController
}

protocol StudyMemberNavigation: AnyObject {
    func presentToMemberVC()
    func presentToMemberDetailVC()
    func dimiss()
}

final class StudyMemberCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: StudyMemberCoordinatorDependencies
    private let studyId: Int

    init(
        navigationController: UINavigationController,
        dependencies: StudyMemberCoordinatorDependencies,
        studyId: Int
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.studyId = studyId
    }
    
    func start() {
        presentToMemberVC()
    }
    
    deinit {
        print("StudyMemberCoordinator - 코디네이터 해제")
    }
}

extension StudyMemberCoordinator: StudyMemberNavigation {
    func presentToMemberVC() {
        let memberVC = dependencies.makeStudyMemberVC(
            coordinator: self,
            studyId: studyId
        )
        
        navigationController.setViewControllers([memberVC], animated: true)
        
        parentCoordinator?.navigationController.presentedViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func presentToMemberDetailVC() {
        let memberDetailVC = dependencies.makeStudyMemberDetailVC(
            coordinator: self
        )

        navigationController.present(memberDetailVC, animated: true, completion: nil)
    }
    
    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
