//
//  StudyListCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol StudyListCoordinatorDependencies {
    func makeStudyListVC(coordinator: StudyListNavigation) -> StudyListViewController
    func makeStudyActivityVC(coordinator: StudyListNavigation) -> StudyActivityViewController
    func makeDetailStudyActivityListVC(coordinator: StudyListNavigation) -> DetailStudyActivityViewController
    func makeCreateActivityCoordinator(navigationController: UINavigationController) -> CreateActivityCoordinator
    func makeDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int, coordinator: StudyListNavigation) -> DetailActivityPhotoListViewController
    func makeDetailActivityMemberListVC(coordinator: StudyListNavigation) -> DetailActivityMemberListViewController
}

protocol StudyListNavigation: AnyObject {
    func goToStudyList()
    func goToStudyActivityList()
    func goToDetailStudyActivityVC()
    func presentToDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int)
    func presentToDetailActivityMemberListVC()
    func startCreateActivityCoordinator()
    func dismiss()
}

final class StudyListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: StudyListCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: StudyListCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
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
        let studyActivityListVC = dependencies.makeStudyActivityVC(coordinator: self)
        studyActivityListVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(studyActivityListVC, animated: true)
    }
    
    func goToDetailStudyActivityVC() {
        let detailStudyActivityVC = dependencies.makeDetailStudyActivityListVC(coordinator: self)
        navigationController.pushViewController(detailStudyActivityVC, animated: true)
    }
    
    func startCreateActivityCoordinator() {
        let createActivityNVC = UINavigationController()
        let flow = dependencies.makeCreateActivityCoordinator(navigationController: createActivityNVC)
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start()
    }
    
    func presentToDetailActivityMemberListVC() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        
        let memberListVC = dependencies.makeDetailActivityMemberListVC(coordinator: self)
        memberListVC.modalPresentationStyle = .fullScreen
        lastVC.present(memberListVC, animated: true)
    }
    
    func presentToDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        
        let detailActivityPhotoListVC = dependencies.makeDetailActivityPhotoListVC(with: imageURLs, selectedRow: row, coordinator: self)
        detailActivityPhotoListVC.modalPresentationStyle = .overFullScreen
        lastVC.present(detailActivityPhotoListVC, animated: true)
    }
    
    func dismiss() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true)
    }
}
