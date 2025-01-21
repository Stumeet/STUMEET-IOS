//
//  HomeDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import UIKit

final class HomeDIContainer: HomeCoordinatorDependencies {
    
    typealias Navigation = HomeNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    
    // MARK: - UseCase
    
 
    // MARK: - Home
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
    func makeHomeVC(coordinator: HomeNavigation) -> HomeViewController {
        HomeViewController(
            coordinator: coordinator,
            viewModel: makeHomeViewModel()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
   
    // MARK: - DIContainers of scenes
    func makeNotificationDIContainer() -> NotificationDIContainer {
        let dependencies = NotificationDIContainer.Dependencies(
            provider: dependencies.provider
        )
        return NotificationDIContainer(dependencies: dependencies)
    }
}
