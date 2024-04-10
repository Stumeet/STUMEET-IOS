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
        startAuthCoordinator()
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
    
    func startRegisterCoordinator() {
        let registerSceneDIContainer = appDIContainer.makeRegisterSceneDIContainer()
        let flow = registerSceneDIContainer.makeRegisterCoordinator(navigationController: navigationController)
        children.removeAll()
        flow.parentCoordinator = self
        children.append(flow)
        flow.start()
    }
    
    func startTabbarCoordinator() {
        let tabbarCoordinator = TabBarCoordinator(navigationController: navigationController)
        children.removeAll()
        tabbarCoordinator.parentCoordinator = self
        tabbarCoordinator.start()
    }
    
}
