//
//  NotificationDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//


import UIKit
import Moya

final class NotificationDIContainer: NotificationCoordinatorDependencies {
    
    typealias Navigation = NotificationNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    func makeNotificationRepository() -> NotificationRepository {
        DefaultNotificationRepository(provider: dependencies.provider.makeProvider())
    }
    
    // MARK: - Use Cases
    func makeFetchNotificationsUseCase() -> FetchNotificationsUseCase {
        DefaultFetchNotificationsUseCase(
            repository: makeNotificationRepository()
        )
    }
    
    // MARK: - Notification
    func makeNotificationViewModel() -> NotificationViewModel {
        NotificationViewModel(
            fetchNotificationsUseCase: makeFetchNotificationsUseCase()
        )
    }

    func makeNotificationVC(coordinator: Navigation) -> NotificationViewController {
        NotificationViewController(
            coordinator: coordinator,
            viewModel: makeNotificationViewModel()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeNotificationCoordinator(navigationController: UINavigationController) -> NotificationCoordinator {
        NotificationCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
