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
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository(provider: dependencies.provider.makeProvider())
    }
    
    // MARK: - UseCase
    func makeFetchClosestActivityUseCase() -> FetchClosestActivityUseCase {
        DefaultFetchClosestActivityUseCase(repository: makeStudyActivityRepository())
    }
    
    func makeFetchClosestActivityListUseCase() -> FetchClosestActivityListUseCase {
        DefaultFetchClosestActivityListUseCase(repository: makeStudyActivityRepository())
    }
    
    func makeFetchNoticesUseCase() -> FetchNoticesUseCase {
        DefaultFetchNoticesUseCase(repository: makeStudyActivityRepository())
    }
    
    // MARK: - Home
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchClosestActivityUseCase: makeFetchClosestActivityUseCase(),
            fetchClosestActivityListUseCase: makeFetchClosestActivityListUseCase(),
            fetchNoticesUseCase: makeFetchNoticesUseCase()
        )
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
