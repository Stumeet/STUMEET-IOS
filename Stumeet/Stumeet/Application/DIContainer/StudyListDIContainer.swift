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
    
    func makeDetailActivityPhotoListUseCase() -> DetailActivityPhotoListUseCase {
        DefualtDetailActivityPhotoListUseCase()
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
    
    func makeDetailStudyActivityListVC(coordinator: Navigation) -> DetailStudyActivityViewController {
        DetailStudyActivityViewController(
            coordinator: coordinator,
            viewModel: makeDetailStudyActivityViewModel()
        )
    }
    
    // MARK: - DetailActivityPhotoList
    
    func makeDetailActivityPhotoListViewModel(with imageURLs: [String], selectedRow row: Int) -> DetailActivityPhotoListViewModel {
        DetailActivityPhotoListViewModel(
            useCase: makeDetailActivityPhotoListUseCase(),
            imageURLs: imageURLs,
            selectedRow: row
        )
    }
    
    func makeDetailActivityPhotoListVC(with imageURLs: [String], selectedRow row: Int, coordinator: Navigation) -> DetailActivityPhotoListViewController {
        DetailActivityPhotoListViewController(
            coordinator: coordinator,
            viewModel: makeDetailActivityPhotoListViewModel(with: imageURLs, selectedRow: row)
        )
    }
    
    // MARK: - DetailActivityMemberList
    
    func makeDetailActivityMemberListViewModel(names: [String]) -> DetailActivityMemberListViewModel {
        DetailActivityMemberListViewModel(names: names)
    }
    
    func makeDetailActivityMemberListVC(coordinator: Navigation, names: [String]) -> DetailActivityMemberListViewController {
        DetailActivityMemberListViewController(
            coordinator: coordinator,
            viewModel: makeDetailActivityMemberListViewModel(names: names)
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
