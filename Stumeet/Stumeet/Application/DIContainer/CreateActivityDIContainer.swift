//
//  CreateActivityDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import UIKit

final class CreateActivityDIContainer: CreateActivityCoordinatorDependencies {
    
    typealias Navigation = CreateActivityNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider?
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeStudyActivityUseCase() -> StudyActivityUseCase {
        DefaultStudyActivityUseCase.init(
            repository: makeStudyActivityRepository()
        )
    }
    
    func makeCreateActivityUseCase() -> CreateActivityUseCase {
        DefaultCreateActivityUseCase()
    }
    
    func makeBottomSheetCalendarUseCase() -> BottomSheetCalendarUseCase {
        DefaultBottomSheetCalendarUseCase()
    }
    
    // MARK: - Repositories
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository()
    }
    
    // MARK: - StudyActivityList
    func makeStudyActivityListViewModel() -> StudyActivityViewModel {
        StudyActivityViewModel(useCase: makeStudyActivityUseCase())
    }
    
    // MARK: - CreateActivity
    func makeCreateActivityViewModel() -> CreateActivityViewModel {
        CreateActivityViewModel(useCase: makeCreateActivityUseCase())
    }
    
    func makeCreateActivityViewController(coordinator: Navigation) -> CreateActivityViewController {
        CreateActivityViewController(
            viewModel: makeCreateActivityViewModel(),
            coordinator: coordinator
        )
    }
    
    // MARK: - StudyActivitySetting
    
    func makeStudyActivitySettingViewModel() -> StudyActivitySettingViewModel {
        StudyActivitySettingViewModel()
    }
    
    func makeStudyActivitySettingViewController(coordinator: Navigation) -> StudyActivitySettingViewController {
        StudyActivitySettingViewController(
            viewModel: makeStudyActivitySettingViewModel(),
            coordinator: coordinator
        )
    }
    
    // MARK: - BottomSheetCalendar
    
    func makeBottomSheetCalendarViewModel() -> BottomSheetCalendarViewModel {
        BottomSheetCalendarViewModel(useCase: makeBottomSheetCalendarUseCase())
    }
    
    func makeBottomSheetCalendarViewController(coordinator: Navigation) -> BottomSheetCalendarViewController {
        BottomSheetCalendarViewController(
            viewModel: makeBottomSheetCalendarViewModel(),
            coordinator: coordinator
        )
    }
    
    // MARK: - Flow Coordinators
    func makeCreateActivityCoordinator(navigationController: UINavigationController) -> CreateActivityCoordinator {
        CreateActivityCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
