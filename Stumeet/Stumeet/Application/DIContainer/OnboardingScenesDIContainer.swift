//
//  OnboardingScenesDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import UIKit
import SwiftUI

final class OnboardingScenesDIContainer: OnboardingFlowCoordinatorDependencies {
    
    // MARK: - Onboarding
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> OnboardingViewController {
        OnboardingViewController.init(viewModel: makeOnboardingViewModel(actions: actions))
    }
    
    func makeOnboardingViewModel(actions: OnboardingViewModelActions) -> OnboardingViewModel {
        DefaultOnboardingViewModel(
            actions: actions
        )
    }
    
    // MARK: - SNS Login
    func makeSnsLoginViewController() -> UIViewController {
        SnsLoginViewController()
    }
    
    // MARK: - Flow Coordinators
    func makeOnboardingFlowCoordinator(navigationController: UINavigationController) -> OnboardingFlowCoordinator {
        OnboardingFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
