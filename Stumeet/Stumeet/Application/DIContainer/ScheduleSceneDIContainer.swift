//
//  ScheduleSceneDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import UIKit
import Moya

final class ScheduleSceneDIContainer: ScheduleCoordinatorDependencies {
    typealias Navigation = ScheduleNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories

    // MARK: - Use Cases
    
    // MARK: - ActivityNotice
    func makeScheduleViewModel(studyId: Int) -> ScheduleViewModel {
        ScheduleViewModel(
            studyID: studyId
        )
    }
    
    func makeScheduleVC(coordinator: Navigation, studyId: Int) -> ScheduleViewController {
        ScheduleViewController(
            coordinator: coordinator,
            viewModel: makeScheduleViewModel(studyId: studyId)
        )
    }
    
    // MARK: - Flow Coordinators
    func makeScheduleCoordinator(navigationController: UINavigationController, studyId: Int) -> ScheduleCoordinator {
        ScheduleCoordinator(
            navigationController: navigationController,
            dependencies: self,
            studyId: studyId
        )
    }
}
