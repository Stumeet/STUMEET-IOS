//
//  AppCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    func start() {
        // !IMP: - 로그아웃 구현 시 삭제 (임시 로그아웃 처리 필요에 따라 주석 해제 후 사용)
//        appDIContainer.keychainManager.removeAllTokens()
        removeKeychainAtFirstLaunch()
        setupLogoutNotification()
        
        let isLoggedIn = appDIContainer.keychainManager.getToken() != nil
        
        if isLoggedIn {
            startTabbarCoordinator()
        } else {
            startAuthCoordinator()
        }
    }
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func startAuthCoordinator() {
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
        let flow = authSceneDIContainer.makeAuthCoordinator(navigationController: navigationController)
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start()
    }
    
    func startTabbarCoordinator() {
        let tabbarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        children.removeAll()
        tabbarCoordinator.parentCoordinator = self
        tabbarCoordinator.start()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Function
extension AppCoordinator {
    private func removeKeychainAtFirstLaunch() {
        guard UserDefaults.isFirstLaunch() else {
            return
        }
        
        // TODO: 오류 케이스 로직 추가 필요
        if appDIContainer.keychainManager.removeAllTokens() {
            print("토큰 삭제 성공")
        } else {
            print("토큰 삭제 실패")
        }
    }
    
    // TODO: - 토큰 만료 플로우 및 로그아웃 처리 기획이 나오는대로 수정
    private func presentLogoutAlert() {
        let alertController = UIAlertController(title: "토큰 만료", message: "재 로그인 필요", preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let presentedVC = navigationController.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    self.startAuthCoordinator()
                }
            } else {
                startAuthCoordinator()
            }
        }
        alertController.addAction(loginAction)
        guard let topController = UIApplication.topViewController(base: navigationController) else { return }
        topController.present(alertController, animated: true)
    }
    
    private func setupLogoutNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: .userDidLogout, object: nil)
    }
    
    @objc private func handleLogout() {
        presentLogoutAlert()
    }
}
