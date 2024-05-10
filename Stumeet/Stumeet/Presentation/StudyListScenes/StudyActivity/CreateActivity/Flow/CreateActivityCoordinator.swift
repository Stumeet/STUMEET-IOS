//
//  CreateActivityCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import Foundation
import UIKit

protocol CreateActivityCoordinatorDependencies {
    func makeCreateActivityViewController(coordinator: CreateActivityNavigation) -> CreateActivityViewController
    func makeStudyActivitySettingViewController(coordinator: CreateActivityNavigation) -> StudyActivitySettingViewController
    func makeBottomSheetCalendarViewController(coordinator: CreateActivityNavigation) -> BottomSheetCalendarViewController
}

protocol CreateActivityNavigation: AnyObject {
    func presentToCreateActivityVC()
    func goToStudyActivitySettingVC()
    func presentToBottomSheetCalendarVC()
    func dismissBottomSheetCalendarVC()
}

final class CreateActivityCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: CreateActivityCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: CreateActivityCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentToCreateActivityVC()
    }
    
    deinit {
        print("StudyActivityCoordinator - 코디네이터 해제")
    }
}

extension CreateActivityCoordinator: CreateActivityNavigation {
    
    func presentToCreateActivityVC() {
        let createActivityVC = dependencies.makeCreateActivityViewController(coordinator: self)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.viewControllers.append(createActivityVC)
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func goToStudyActivitySettingVC() {
        let studyActivitySettingVC = dependencies.makeStudyActivitySettingViewController(coordinator: self)
        navigationController.pushViewController(studyActivitySettingVC, animated: true)
    }
    
    func presentToBottomSheetCalendarVC() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let bottomSheetCalendarVC = dependencies.makeBottomSheetCalendarViewController(coordinator: self)
        
        bottomSheetCalendarVC.modalPresentationStyle = .overFullScreen
        lastVC.present(bottomSheetCalendarVC, animated: false)
    }
    
    func dismissBottomSheetCalendarVC() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true)
    }
}
