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
    func makeStudyMemberAchievementVC(coordinator: StudyMemberNavigation) -> StudyMemberAchievementViewController
}

protocol StudyMemberNavigation: AnyObject {
    func presentToMemberVC()
    func presentToMemberDetailVC()
    func presentToComplimentPopup(from viewController: UIViewController)
    func presentToExpulsionPopup(
        from viewController: UIViewController,
        delegate: StumeetConfirmationPopupViewControllerDelegate,
        popupContextView: UIView
    )
    func goToMemberAchievementVC()
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
        navigationController.presentationController?.delegate = memberVC

        parentCoordinator?.navigationController.presentedViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func presentToMemberDetailVC() {
        let memberDetailVC = dependencies.makeStudyMemberDetailVC(
            coordinator: self
        )

        navigationController.present(memberDetailVC, animated: true, completion: nil)
    }
    
    func presentToComplimentPopup(from viewController: UIViewController) {
        let complimentPopupVC = StudyMemberComplimentPopupViewController()
        complimentPopupVC.modalPresentationStyle = .overFullScreen
        complimentPopupVC.modalTransitionStyle = .crossDissolve
        viewController.present(complimentPopupVC, animated: false, completion: nil)
    }
    
    func presentToExpulsionPopup(
        from viewController: UIViewController,
        delegate: StumeetConfirmationPopupViewControllerDelegate,
        popupContextView: UIView
    ) {
        let exitPopupVC = StumeetConfirmationPopupViewController(contextView: popupContextView)
        exitPopupVC.delegate = delegate
        exitPopupVC.modalPresentationStyle = .overFullScreen
        exitPopupVC.modalTransitionStyle = .crossDissolve
        viewController.present(exitPopupVC, animated: false, completion: nil)
    }
    
    func goToMemberAchievementVC() {
        let memberAchievementVC = dependencies.makeStudyMemberAchievementVC(
            coordinator: self
        )

        navigationController.pushViewController(memberAchievementVC, animated: true)
    }
    
    func dimiss() {
        self.navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
