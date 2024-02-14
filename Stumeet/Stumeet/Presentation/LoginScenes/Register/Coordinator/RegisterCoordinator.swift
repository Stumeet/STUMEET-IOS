//
//  RegisterCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit
import PhotosUI

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
        let nicknameVC = NicknameViewController()
        navigationController.pushViewController(nicknameVC, animated: true)
    }
    
    func presentPHPickerView(pickerVC: PHPickerViewController) {
        let imagePicker = pickerVC
        imagePicker.modalPresentationStyle = .fullScreen
        navigationController.present(imagePicker, animated: true)
    }
}
