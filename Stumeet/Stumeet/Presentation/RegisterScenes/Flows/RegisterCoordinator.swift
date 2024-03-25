//
//  RegisterCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/24.
//

import UIKit
import PhotosUI
import Moya

final class RegisterCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        let useCase = DefaultChangeProfileUseCase()
        let changeVC = ChangeProfileViewController(
            viewModel: ChangeProfileViewModel(useCase: useCase),
            coordinator: self)
        navigationController.pushViewController(changeVC, animated: true)
    }
    
    func goToNickNameVC(image: Data) {
        let provider = MoyaProvider<RegisterService>()
        let register = Register(
            profileImage: image,
            nickname: nil,
            region: nil,
            field: nil)
        let useCase = DefaultNicknameUseCase(repository: DefaultNicknameRepository(provider: provider))
        let nicknameVC = NicknameViewController(
            viewModel: NicknameViewModel(useCase: useCase, register: register),
            coordinator: self)
        navigationController.pushViewController(nicknameVC, animated: true)
    }
    
    func goToSelectRegionVC(register: Register) {
        let useCase = DefaultSelectRegionUseCase(repository: DefaultRegionRepository())
        let selectRegionVC = SelectRegionViewController(
            viewModel: SelectRegionViewModel(useCase: useCase, register: register),
            coordinator: self)
        navigationController.pushViewController(selectRegionVC, animated: true)
    }
    
    func goToSelectFieldVC(register: Register) {
        let provider = MoyaProvider<RegisterService>()
        let useCase = DefaultSelectFieldUseCase(repository: DefaultSelectFieldRepository(provider: provider))
        let selectFieldVC = SelectFieldViewController(
            viewModel: SelecteFieldViewModel(useCase: useCase, register: register),
            coordinator: self)
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
        let provider = MoyaProvider<RegisterService>()
        let useCase = DefaultStartUseCase(repository: DefualtStartRepository(provider: provider))
        let startVC = StartViewController(viewModel: StartViewModel(useCase: useCase, register: register), coordinator: self)
        
        startVC.transitioningDelegate = lastVC
        startVC.modalPresentationStyle = .fullScreen
        lastVC.present(startVC, animated: true)
    }
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
