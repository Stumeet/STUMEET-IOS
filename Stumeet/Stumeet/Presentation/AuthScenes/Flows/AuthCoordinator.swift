//
//  AuthCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit
import PhotosUI
import Moya

protocol AuthCoordinatorDependencies {
    func makeSnsLoginViewController(coordinator: AuthNavigation) -> SnsLoginViewController
    func makeOnboardingViewController(coordinator: AuthNavigation) -> OnboardingViewController
    func makeChangeProfileViewController(coordinator: AuthNavigation) -> ChangeProfileViewController
    func makeNicknameViewController(image: Data, coordinator: AuthNavigation) -> NicknameViewController
    func makeSelectRegionViewController(register: Register, coordinator: AuthNavigation) -> SelectRegionViewController
    func makeSelectFieldViewController(register: Register, coordinator: AuthNavigation) -> SelectFieldViewController
    func makeStartViewController(register: Register, coordinator: AuthNavigation) -> StartViewController
}

protocol AuthNavigation: AnyObject {
    func goToSnsLoginVC()
    func goToOnboardingVC()
    func goToHomeVC()
    func goToChangeProfileVC()
    func goToNickNameVC(image: Data)
    func goToSelectRegionVC(register: Register)
    func goToSelectFieldVC(register: Register)
    func presentPHPickerView(pickerVC: PHPickerViewController)
    func presentToStartVC(register: Register)
}

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: AuthCoordinatorDependencies

    init(navigationController: UINavigationController,
         dependencies: AuthCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        if UserDefaults.standard.bool(forKey: "SHOW_ONBOARDING_VC") {
            goToSnsLoginVC()
        } else {
            goToOnboardingVC()
        }
    }
    
    deinit {
        print("AuthCoordinator - 코디네이터 해제")
    }
}

extension AuthCoordinator: AuthNavigation {
    func goToSnsLoginVC() {
        let snsLoginVC = dependencies.makeSnsLoginViewController(coordinator: self)
        navigationController.pushViewController(snsLoginVC, animated: true)
        UserDefaults.standard.set(true, forKey: "SHOW_ONBOARDING_VC")
    }
    
    func goToOnboardingVC() {
        let onboardingVC = dependencies.makeOnboardingViewController(coordinator: self)
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func goToChangeProfileVC() {
        let changeVC = dependencies.makeChangeProfileViewController(coordinator: self)
        navigationController.pushViewController(changeVC, animated: true)
    }
    
    func goToNickNameVC(image: Data) {
        let nicknameVC = dependencies.makeNicknameViewController(image: image, coordinator: self)
        navigationController.pushViewController(nicknameVC, animated: true)
    }
    
    func goToSelectRegionVC(register: Register) {
        let selectRegionVC = dependencies.makeSelectRegionViewController(register: register, coordinator: self)
        navigationController.pushViewController(selectRegionVC, animated: true)
    }
    
    func goToSelectFieldVC(register: Register) {
        let selectFieldVC = dependencies.makeSelectFieldViewController(register: register, coordinator: self)
        navigationController.pushViewController(selectFieldVC, animated: true)
    }
    
    func goToHomeVC() {
        // !IMP: StartVC의 경우 modal이기에 일단은 dismiss로 모달을 닫고 홈으로 넘어 가게 만들었지만 동작이 어색하기에
        // 로직 수정이 필요할 것으로 보임
        let appCoordinator = parentCoordinator as! AppCoordinator
        
        let completion = {
            appCoordinator.startTabbarCoordinator()
            appCoordinator.childDidFinish(self)
        }
        
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: completion)
        } else {
            completion()
        }
        
    }
    
    func presentPHPickerView(pickerVC: PHPickerViewController) {
        let imagePicker = pickerVC
        imagePicker.modalPresentationStyle = .fullScreen
        navigationController.present(imagePicker, animated: true)
    }
    
    func presentToStartVC(register: Register) {
        guard let lastVC = navigationController.viewControllers.last as? SelectFieldViewController else { return }

        let startVC = dependencies.makeStartViewController(register: register, coordinator: self)
        
        startVC.transitioningDelegate = lastVC
        startVC.modalPresentationStyle = .fullScreen
        lastVC.present(startVC, animated: true)
    }
}
