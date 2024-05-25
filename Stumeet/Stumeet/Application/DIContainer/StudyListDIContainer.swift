//
//  StudyListDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import UIKit

final class StudyListDIContainer: StudyListCoordinatorDependencies {
    
    typealias Navigation = StudyListNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider?
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository()
    }
    
    func makeDetailsudyActivityRepository() -> DetailStudyActivityRepository {
        // MARK: - TODO netwokring 후 Default로 교체
        MockDetailStudyActivityRepository()
    }
    
    // MARK: - UseCase
    
    func makeStudyActivityUseCase() -> StudyActivityUseCase {
        DefaultStudyActivityUseCase(repository: makeStudyActivityRepository())
    }
    
    func makeDetailStudyActivityUseCase() -> DetailStudyActivityUseCase {
        DefaultDetailStudyActivityUseCase(repository: makeDetailsudyActivityRepository())
    }
    
    // MARK: - StudyList
    
    func makeStudyListVC(coordinator: Navigation) -> StudyListViewController {
        StudyListViewController(coordinator: coordinator)
    }
    
    // MARK: - StudyActivityList
    func makeStudyActivityListVM() -> StudyActivityViewModel {
        StudyActivityViewModel(useCase: makeStudyActivityUseCase())
    }
    
    func makeStudyActivityListVC(coordinator: Navigation) -> StudyActivityListViewController {
        StudyActivityListViewController(
            viewModel: makeStudyActivityListVM(),
            coordinator: coordinator)
    }
    
    // MARK: - DetailStudyActivity
    
    func makeDetailStudyActivityViewModel() -> DetailStudyActivityViewModel {
        DetailStudyActivityViewModel(useCase: makeDetailStudyActivityUseCase())
    }
    
    func makeDetailStudyActivityListVC(coordinator: any StudyListNavigation) -> DetailStudyActivityViewController {
        DetailStudyActivityViewController(
            coordinator: coordinator,
            viewModel: makeDetailStudyActivityViewModel()
        )
    }
    
    // MARK: - DIContainer
    func makeCreateActivityDIContainer() -> CreateActivityDIContainer {
        let dependencies = CreateActivityDIContainer.Dependencies(provider: nil)
        return CreateActivityDIContainer(dependencies: dependencies)
    }
    
    // MARK: - Flow Coordinators
    func makeCreateActivityCoordinator(navigationController: UINavigationController) -> CreateActivityCoordinator {
        return CreateActivityCoordinator(
            navigationController: navigationController,
            dependencies: makeCreateActivityDIContainer()
        )
    }
}
