//
//  OnboardingFlowCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import UIKit

protocol OnboardingFlowCoordinatorDependencies {
    func makeOnboardingViewController(
        actions: OnboardingViewModelActions
    ) -> OnboardingViewController
    func makeSnsLoginViewController() -> UIViewController
}

final class OnboardingFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: OnboardingFlowCoordinatorDependencies

    private weak var onboardingVC: OnboardingViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: OnboardingFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = OnboardingViewModelActions(showSnsLogin: showSnsLogin)
        let viewController = dependencies.makeOnboardingViewController(actions: actions)

        navigationController?.pushViewController(viewController, animated: false)
        onboardingVC = viewController
    }

    private func showSnsLogin() {
        let viewController = dependencies.makeSnsLoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
