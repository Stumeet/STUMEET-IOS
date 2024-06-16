//
//  HomeCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol HomeNavigation: AnyObject {
    func goToHome()
    func goToAuthVC()
    func presentLogoutAlert()
}

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToHome()
    }
}

extension HomeCoordinator: HomeNavigation {
    func goToHome() {
        let homeVC = HomeViewController(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func goToAuthVC() {
        let appCoordinator = parentCoordinator as! AppCoordinator
        appCoordinator.startAuthCoordinator()
        appCoordinator.childDidFinish(self)
    }
    
    // TODO: - 토큰 만료 플로우 및 로그아웃 처리 기획이 나오는대로 수정
    func presentLogoutAlert() {
        let alertController = UIAlertController(title: "토큰 만료", message: "재 로그인 필요", preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            if let presentedVC = self?.navigationController.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    self?.goToAuthVC()
                }
            } else {
                self?.goToAuthVC()
            }
        }
        alertController.addAction(loginAction)
        
        guard let topController = UIApplication.topViewController() else { return }
        topController.present(alertController, animated: true, completion: nil)
    }
}
