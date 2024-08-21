//
//  CreateStudyGroupCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 7/24/24.
//

import UIKit
import PhotosUI

protocol CreateStudyGroupCoordinatorDependencies {
    func makeCreateStudyGroupVC(coordinator: CreateStudyGroupNavigation) -> CreateStudyGroupViewController
    func makeSelectStudyGroupItemVC(coordinator: CreateStudyGroupNavigation, type: CreateStudySelectItemType) -> SelectStudyGroupItemViewController
    func makeSetStudyGroupPeriodVC(coordinator: CreateStudyGroupNavigation, dates: (isStart: Bool, startDate: Date, endDate: Date?)) -> SetStudyGroupPeriodViewController
    func makeSelectStudyTimeVC(coordinator: CreateStudyGroupNavigation) -> SelectStudyTimeViewController
}

protocol CreateStudyGroupNavigation: AnyObject {
    func presentToCreateStudyGroupVC()
    func navigateToSelectStudyGroupItemVC(delegate: SelectStudyGroupItemDelegate, type: CreateStudySelectItemType)
    func popToCreateStudyGroupVC()
    func presentToSetPeriodCalendarVC(delegate: SetStudyGroupPeriodDelegate, dates: (isStart: Bool, startDate: Date, endDate: Date?))
    func presentToSelectStudyTimeVC(delegate: SelectStudyTimeDelegate)
    func presentPHPickerView(pickerVC: PHPickerViewController)
    func dismiss()
}

final class CreateStudyGroupCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: CreateStudyGroupCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: CreateStudyGroupCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentToCreateStudyGroupVC()
    }
}

extension CreateStudyGroupCoordinator: CreateStudyGroupNavigation {
    
    func presentToCreateStudyGroupVC() {
        let createActivityVC = dependencies.makeCreateStudyGroupVC(coordinator: self)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.viewControllers.append(createActivityVC)
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func navigateToSelectStudyGroupItemVC(delegate: SelectStudyGroupItemDelegate, type: CreateStudySelectItemType) {
        let fieldVC = dependencies.makeSelectStudyGroupItemVC(coordinator: self, type: type)
        fieldVC.delegate = delegate
        navigationController.pushViewController(fieldVC, animated: true)
    }
    
    func popToCreateStudyGroupVC() {
        navigationController.popViewController(animated: true)
    }
    
    func presentToSetPeriodCalendarVC(delegate: SetStudyGroupPeriodDelegate, dates: (isStart: Bool, startDate: Date, endDate: Date?)) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let calendarVC = dependencies.makeSetStudyGroupPeriodVC(coordinator: self, dates: dates)
        calendarVC.delegate = delegate
        calendarVC.modalPresentationStyle = .overFullScreen
        navigationController.present(calendarVC, animated: false)
    }
    
    func presentToSelectStudyTimeVC(delegate: SelectStudyTimeDelegate) {
        guard let lastVC = navigationController.viewControllers.last else { return }
        let selectTimeVC = dependencies.makeSelectStudyTimeVC(coordinator: self)
        selectTimeVC.modalPresentationStyle = .overFullScreen
        selectTimeVC.delegate = delegate
        navigationController.present(selectTimeVC, animated: false)
    }
    
    func presentPHPickerView(pickerVC: PHPickerViewController) {
        let imagePicker = pickerVC
        imagePicker.modalPresentationStyle = .fullScreen
        navigationController.present(imagePicker, animated: true)
    }
    
    func dismiss() {
        guard let lastVC = navigationController.viewControllers.last else { return }
        lastVC.dismiss(animated: false)
    }
    
    
}
