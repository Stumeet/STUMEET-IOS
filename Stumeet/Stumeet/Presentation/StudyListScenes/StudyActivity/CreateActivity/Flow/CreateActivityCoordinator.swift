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
    func makeBottomSheetCalendarViewController(coordinator: CreateActivityNavigation, isStart: Bool) -> BottomSheetCalendarViewController
}

protocol CreateActivityNavigation: AnyObject {
    func presentToCreateActivityVC()
    func goToStudyActivitySettingVC()
    func presentToBottomSheetCalendarVC(isStart: Bool)
    func dismissStartDateCalendarVC(date: String?)
    func dismissEndDateCalendarVC(date: String?)
}

protocol CreateActivityCoordinatorDelegate: AnyObject {
    func didTapStartDateCompleteButton(date: String)
    func didTapEndDateCompleteButton(date: String)
}

final class CreateActivityCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: CreateActivityCoordinatorDelegate?
    
    private let dependencies: CreateActivityCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: CreateActivityCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentToCreateActivityVC()
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
        delegate = studyActivitySettingVC
        navigationController.pushViewController(studyActivitySettingVC, animated: true)
    }

    
    func presentToBottomSheetCalendarVC(isStart: Bool) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let bottomSheetCalendarVC = dependencies.makeBottomSheetCalendarViewController(coordinator: self, isStart: isStart)
        bottomSheetCalendarVC.modalPresentationStyle = .overFullScreen
        lastVC.present(bottomSheetCalendarVC, animated: false)
    }
    
    func dismissStartDateCalendarVC(date: String?) {
        if let date = date {
            delegate?.didTapStartDateCompleteButton(date: date)
        }
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true)
    }
    
    func dismissEndDateCalendarVC(date: String?) {
        if let date = date {
            delegate?.didTapEndDateCompleteButton(date: date)
        }
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true)
    }
}
