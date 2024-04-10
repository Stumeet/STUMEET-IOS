//
//  RegisterCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/24.
//

import UIKit
import PhotosUI
import Moya

protocol RegisterCoordinatorDependencies {
    func makeChangeProfileViewController(coordinator: RegisterNavigation) -> ChangeProfileViewController
    func makeNicknameViewController(image: Data, coordinator: RegisterNavigation) -> NicknameViewController
    func makeSelectRegionViewController(register: Register, coordinator: RegisterNavigation) -> SelectRegionViewController
    func makeSelectFieldViewController(register: Register, coordinator: RegisterNavigation) -> SelectFieldViewController
    func makeStartViewController(register: Register, coordinator: RegisterNavigation) -> StartViewController
}

protocol RegisterNavigation: AnyObject {
    func goToChangeProfileVC()
    func goToNickNameVC(image: Data)
    func goToSelectRegionVC(register: Register)
    func goToSelectFieldVC(register: Register)
    func goToHomeVC()
    func presentPHPickerView(pickerVC: PHPickerViewController)
    func presentToStartVC(register: Register)
}

final class RegisterCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: RegisterCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: RegisterCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        goToChangeProfileVC()
    }
    
    deinit {
        print("RegisterCoordinator - 코디네이터 해제")
    }
}

extension RegisterCoordinator: RegisterNavigation {

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
