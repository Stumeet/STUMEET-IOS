//
//  CreateActivityCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import Foundation
import UIKit
import PhotosUI

protocol CreateActivityCoordinatorDependencies {
    func makeCreateActivityViewController(coordinator: CreateActivityNavigation) -> CreateActivityViewController
    func makeStudyActivitySettingViewController(coordinator: CreateActivityNavigation) -> StudyActivitySettingViewController
    func makeBottomSheetCalendarViewController(coordinator: CreateActivityNavigation, isStart: Bool) -> BottomSheetCalendarViewController
    func makeActivityMemberSettingViewController(coordinator: CreateActivityNavigation) -> ActivityMemberSettingViewController
    func makePHPickerViewController() -> PHPickerViewController
}

protocol CreateActivityNavigation: AnyObject {
    func presentToCreateActivityVC()
    func goToStudyActivitySettingVC()
    func presentToBottomSheetCalendarVC(delegate: CreateActivityDelegate, isStart: Bool)
    func presentToActivityMemberSettingViewController(delegate: CreateActivityMemberDelegate)
    func presentToPHPickerVC(delegate: PHPickerViewControllerDelegate)
    func dismiss()
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

    
    func presentToBottomSheetCalendarVC(delegate: CreateActivityDelegate, isStart: Bool) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let bottomSheetCalendarVC = dependencies.makeBottomSheetCalendarViewController(coordinator: self, isStart: isStart)
        bottomSheetCalendarVC.modalPresentationStyle = .overFullScreen
        bottomSheetCalendarVC.delegate = delegate
        lastVC.present(bottomSheetCalendarVC, animated: false)
    }
    
    func presentToActivityMemberSettingViewController(delegate: CreateActivityMemberDelegate) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let activityMemberSettingVC = dependencies.makeActivityMemberSettingViewController(coordinator: self)
        activityMemberSettingVC.modalPresentationStyle = .fullScreen
        activityMemberSettingVC.delegate = delegate
        lastVC.present(activityMemberSettingVC, animated: true)
    }
    
    func presentToPHPickerVC(delegate: PHPickerViewControllerDelegate) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let pickerVC = dependencies.makePHPickerViewController()
        pickerVC.delegate = delegate
        lastVC.present(pickerVC, animated: true)
    }
    
    func dismiss() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true) {
            self.parentCoordinator?.childDidFinish(self)
        }
    }
}
