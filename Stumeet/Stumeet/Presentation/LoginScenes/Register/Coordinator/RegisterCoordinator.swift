//
//  RegisterCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit
import PhotosUI

import Moya

class RegisterCoordinator: Coordinator {
    
    // TODO: 온보딩 Coordinator와 결합
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let useCase = DefaultChangeProfileUseCase()
        let changeVC = ChangeProfileViewController(
            viewModel: ChangeProfileViewModel(useCase: useCase),
            coordinator: self)
        childCoordinators.append(self)
        navigationController.pushViewController(changeVC, animated: true)
    }
    
    func navigateToNickNameVC(image: Data) {
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
    
    func navigateToSelectRegionVC(register: Register) {
        let useCase = DefaultSelectRegionUseCase(repository: DefaultRegionRepository())
        let selectRegionVC = SelectRegionViewController(
            viewModel: SelectRegionViewModel(useCase: useCase, register: register),
            coordinator: self)
        navigationController.pushViewController(selectRegionVC, animated: true)
    }
    
    func navigateToSelectFieldVC(register: Register) {
        let provider = MoyaProvider<RegisterService>()
        let useCase = DefaultSelectFieldUseCase(repository: DefaultSelectFieldRepository(provider: provider))
        let selectFieldVC = SelectFieldViewController(
            viewModel: SelecteFieldViewModel(useCase: useCase, register: register),
            coordinator: self)
        navigationController.pushViewController(selectFieldVC, animated: true)
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
    
    func presentToTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
    }
}
