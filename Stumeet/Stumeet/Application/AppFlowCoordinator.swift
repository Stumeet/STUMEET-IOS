//
//  AppFlowCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let onboardingScenesDIContainer = appDIContainer.makeOnboardingScenesDIContainer()
        let flow = onboardingScenesDIContainer.makeOnboardingFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
