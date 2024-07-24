//
//  MyStudyGroupListCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol MyStudyGroupListCoordinatorDependencies {
    func makeMyStudyGroupListVC(coordinator: MyStudyGroupListNavigation) -> MyStudyGroupListViewController
    func makeStudyActivityVC(coordinator: MyStudyGroupListNavigation) -> StudyActivityViewController
    func makeDetailStudyActivityVC(coordinator: MyStudyGroupListNavigation, studyID: Int, activityID: Int) -> DetailStudyActivityViewController
    func makeCreateActivityCoordinator(navigationController: UINavigationController, activity: ActivityCategory) -> CreateActivityCoordinator
    func makeDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int, coordinator: MyStudyGroupListNavigation) -> DetailActivityPhotoListViewController
    func makeDetailActivityMemberListVC(coordinator: MyStudyGroupListNavigation, studyID: Int, activityID: Int) -> DetailActivityMemberListViewController
    func makeCreateStudyGroupCoordinator(navigationController: UINavigationController) -> CreateStudyGroupCoordinator
}

protocol MyStudyGroupListNavigation: AnyObject {
    func goToMyStudyGroupList()
    func goToStudyMain(with id: Int)
    func presentToSideMenu(from viewController: UIViewController)
    func presentToExitPopup(from viewController: UIViewController)
    func presentToInvitationPopup(from viewController: UIViewController)
    func goToStudyActivityList()
    func goToDetailStudyActivityVC(studyID: Int, activityID: Int)
    func presentToDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int)
    func presentToDetailActivityMemberListVC(studyID: Int, activityID: Int)
    func startCreateActivityCoordinator(activity: ActivityCategory)
    func startCreateStudyGroupCoordinator()
    func popViewController()
    func dismiss()
}

final class MyStudyGroupListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: MyStudyGroupListCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: MyStudyGroupListCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        goToMyStudyGroupList()
    }
}

extension MyStudyGroupListCoordinator: MyStudyGroupListNavigation {
    
    func goToMyStudyGroupList() {
        let studyListVC = dependencies.makeMyStudyGroupListVC(coordinator: self)
        navigationController.pushViewController(studyListVC, animated: true)
    }
    
    // TODO: 메인 화면 API 연결 시 수정
    func goToStudyMain(with id: Int) {
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
      
    func goToStudyActivityList() {
        let studyActivityListVC = dependencies.makeStudyActivityVC(coordinator: self)
        studyActivityListVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(studyActivityListVC, animated: true)
    }
    
    func goToDetailStudyActivityVC(studyID: Int, activityID: Int) {
        let detailStudyActivityVC = dependencies.makeDetailStudyActivityVC(coordinator: self, studyID: studyID, activityID: activityID)
        navigationController.pushViewController(detailStudyActivityVC, animated: true)
    }
    
    func startCreateActivityCoordinator(activity: ActivityCategory) {
        let createActivityNVC = UINavigationController()
        let flow = dependencies.makeCreateActivityCoordinator(
            navigationController: createActivityNVC,
            activity: activity
        )
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start(category: activity)
    }
    
    func startCreateStudyGroupCoordinator() {
        let createStudyGroupNVC = UINavigationController()
        let flow = dependencies.makeCreateStudyGroupCoordinator(
            navigationController: createStudyGroupNVC
        )
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start()
    }
    
    func presentToDetailActivityMemberListVC(studyID: Int, activityID: Int) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        
        let memberListVC = dependencies.makeDetailActivityMemberListVC(coordinator: self, studyID: studyID, activityID: activityID)
        memberListVC.modalPresentationStyle = .fullScreen
        lastVC.present(memberListVC, animated: true)
    }
    
    func presentToDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        
        let detailActivityPhotoListVC = dependencies.makeDetailActivityPhotoListVC(with: imageURLs, selectedRow: row, coordinator: self)
        detailActivityPhotoListVC.modalPresentationStyle = .overFullScreen
        lastVC.present(detailActivityPhotoListVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true)
    }
}
