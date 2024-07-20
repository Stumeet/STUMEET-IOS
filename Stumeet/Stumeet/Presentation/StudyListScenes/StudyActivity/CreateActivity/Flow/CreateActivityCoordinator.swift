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
    func makeCreateActivityViewController(coordinator: CreateActivityNavigation, category: ActivityCategory) -> CreateActivityViewController
    func makeStudyActivitySettingViewController(activity: CreateActivity, coordinator: CreateActivityNavigation) -> StudyActivitySettingViewController
    func makeBottomSheetCalendarViewController(coordinator: CreateActivityNavigation, isStart: Bool) -> BottomSheetCalendarViewController
    func makeActivityMemberSettingViewController(member: [ActivityMember], coordinator: CreateActivityNavigation) -> ActivityMemberSettingViewController
    func makeCreateActivityLinkPopUpViewController(coordinator: CreateActivityNavigation) -> CreateActivityLinkPopUpViewController
    func makeActivityPlaceSettingViewController(coordinator: CreateActivityNavigation) -> ActivityPlaceSettingViewController
    func makePHPickerViewController() -> PHPickerViewController
}

protocol CreateActivityNavigation: AnyObject {
    func presentToCreateActivityVC(category: ActivityCategory)
    func goToStudyActivitySettingVC(activity: CreateActivity)
    func presentToBottomSheetCalendarVC(delegate: CreateActivityDelegate, isStart: Bool)
    func presentToActivityMemberSettingViewController(member: [ActivityMember], delegate: CreateActivityMemberDelegate)
    func presentToPHPickerVC(delegate: PHPickerViewControllerDelegate)
    func presentToLinkPopUpVC(delegate: CreateActivityLinkDelegate)
    func presentToActivityPlaceSettingVC(delegate: CreateActivityPlaceDelegate)
    func dismiss()
    func popViewController()
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
        
    }
    
    func start(category: ActivityCategory) {
        presentToCreateActivityVC(category: category)
    }
}

extension CreateActivityCoordinator: CreateActivityNavigation {
    
    func presentToCreateActivityVC(category: ActivityCategory) {
        let createActivityVC = dependencies.makeCreateActivityViewController(coordinator: self, category: category)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.viewControllers.append(createActivityVC)
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func goToStudyActivitySettingVC(activity: CreateActivity) {
        let studyActivitySettingVC = dependencies.makeStudyActivitySettingViewController(activity: activity, coordinator: self)
        navigationController.pushViewController(studyActivitySettingVC, animated: true)
    }

    
    func presentToBottomSheetCalendarVC(delegate: CreateActivityDelegate, isStart: Bool) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let bottomSheetCalendarVC = dependencies.makeBottomSheetCalendarViewController(coordinator: self, isStart: isStart)
        bottomSheetCalendarVC.modalPresentationStyle = .overFullScreen
        bottomSheetCalendarVC.delegate = delegate
        lastVC.present(bottomSheetCalendarVC, animated: false)
    }
    
    func presentToActivityMemberSettingViewController(member: [ActivityMember], delegate: CreateActivityMemberDelegate) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let activityMemberSettingVC = dependencies.makeActivityMemberSettingViewController(member: member, coordinator: self)
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
    
    func presentToLinkPopUpVC(delegate: CreateActivityLinkDelegate) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let linkPopUpVC = dependencies.makeCreateActivityLinkPopUpViewController(coordinator: self)
        linkPopUpVC.modalPresentationStyle = .overFullScreen
        linkPopUpVC.modalTransitionStyle = .crossDissolve
        linkPopUpVC.delegate = delegate
        lastVC.present(linkPopUpVC, animated: true)
        
    }
    
    func presentToActivityPlaceSettingVC(delegate: CreateActivityPlaceDelegate) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let placeVC = dependencies.makeActivityPlaceSettingViewController(coordinator: self)
        placeVC.modalPresentationStyle = .fullScreen
        placeVC.delegate = delegate
        lastVC.present(placeVC, animated: true)
    }
    
    func dismiss() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: true) {
            self.parentCoordinator?.childDidFinish(self)
        }
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
