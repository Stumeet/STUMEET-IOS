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
    
    // TODO: 온보딩 Coordinator와 분리하거나 결합
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let changeVC = ChangeProfileViewController(viewModel: ChangeProfileViewModel(), coordinator: self)
        childCoordinators.append(self)
        navigationController.pushViewController(changeVC, animated: true)
    }
    
    func navigateToNickNameVC() {
        let provider = MoyaProvider<RegisterService>()
        let useCase = DefaultNicknameUseCase(repository: DefaultNicknameRepository(provider: provider))
        let nicknameVC = NicknameViewController(viewModel: NicknameViewModel(useCase: useCase), coordinator: self)
        navigationController.pushViewController(nicknameVC, animated: true)
    }
    
    func navigateToSelectRegionVC() {
        let useCase = DefaultSelectRegionUseCase(repository: DefaultRegionRepository())
        let selectRegionVC = SelectRegionViewController(
            viewModel: SelectRegionViewModel(useCase: useCase),
            coordinator: self)
        navigationController.pushViewController(selectRegionVC, animated: true)
    }
    
    func navigateToSelectFieldVC() {
        
        let useCase = DefaultSelectFieldUseCase(repository: DefaultSelectFieldRepository())
        let selectFieldVC = SelectFieldViewController(
            viewModel: SelecteFieldViewModel(useCase: useCase),
            coordinator: self)
        navigationController.pushViewController(selectFieldVC, animated: true)
    }
    
    func presentPHPickerView(pickerVC: PHPickerViewController) {
        let imagePicker = pickerVC
        imagePicker.modalPresentationStyle = .fullScreen
        navigationController.present(imagePicker, animated: true)
    }
    
    func presentToTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
    }
}
