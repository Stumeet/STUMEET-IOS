//
//  AlarmDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//


import UIKit
import Moya

final class AlarmDIContainer: AlarmCoordinatorDependencies {
    
    typealias Navigation = AlarmNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    
    
    // MARK: - Use Cases

    
    // MARK: - Alarm

    func makeAlarmViewModel() -> AlarmViewModel {
        AlarmViewModel()
    }

    func makeAlarmVC(coordinator: Navigation) -> AlarmViewController {
        AlarmViewController(
            coordinator: coordinator,
            viewModel: makeAlarmViewModel()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeAlarmCoordinator(navigationController: UINavigationController) -> AlarmCoordinator {
        AlarmCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
