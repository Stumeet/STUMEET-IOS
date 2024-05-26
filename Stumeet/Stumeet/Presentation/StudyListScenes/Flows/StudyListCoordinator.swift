//
//  StudyListCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol StudyListNavigation: AnyObject {
    func goToStudyList()
    func goToStudyMain()
    func presentToSideMenu(from viewController: UIViewController)
    func presentToExitPopup(from viewController: UIViewController)
    func presentToInvitationPopup(from viewController: UIViewController)
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
    
    func goToStudyMain() {
        let studyMainVC = StudyMainViewController(coordinator: self)
        studyMainVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(studyMainVC, animated: true)
    }
    
    func presentToSideMenu(from viewController: UIViewController) {
        let sideMenuVC = StudyMainSideMenuViewController(coordinator: self)
        sideMenuVC.modalPresentationStyle = .overFullScreen
        sideMenuVC.modalTransitionStyle = .crossDissolve
        viewController.present(sideMenuVC, animated: false, completion: nil)
    }
    
    func presentToExitPopup(from viewController: UIViewController) {
        let exitPopupVC = StudyMainExitPopupViewController()
        exitPopupVC.modalPresentationStyle = .overFullScreen
        exitPopupVC.modalTransitionStyle = .crossDissolve
        viewController.present(exitPopupVC, animated: false, completion: nil)
    }
    
    func presentToInvitationPopup(from viewController: UIViewController) {
        let invitationPopupVC = StudyMainInvitationPopupViewController()
        invitationPopupVC.modalPresentationStyle = .overFullScreen
        invitationPopupVC.modalTransitionStyle = .crossDissolve
        viewController.present(invitationPopupVC, animated: false, completion: nil)
    }
}
