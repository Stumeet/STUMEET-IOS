//
//  CalenderDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/20.
//

import UIKit

final class CalenderDIContainer: CalenderCoordinatorDependencies {
    
    typealias Navigation = CalenderNavigation
    
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
    func makeFetchMonthlyActivitiesUseCase() -> FetchMonthlyActivitiesUseCase {
        DefaultFetchMonthlyActivitiesUseCase(
            repository: makeStudyActivityRepository()
        )
    }
 
    // MARK: - Calender
    func makeCalenderViewModel() -> CalenderViewModelImpl {
        CalenderViewModelImpl(fetchMonthlyActivitiesUseCase: makeFetchMonthlyActivitiesUseCase())
    }
    
    func makeCalenderVC(coordinator: CalenderNavigation) -> CalenderViewController {
        CalenderViewController(
            coordinator: coordinator,
            viewModel: makeCalenderViewModel()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeCalenderCoordinator(navigationController: UINavigationController) -> CalenderCoordinator {
        return CalenderCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
   
    // MARK: - DIContainers of scenes
}
