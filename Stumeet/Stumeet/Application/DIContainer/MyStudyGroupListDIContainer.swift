//
//  MyStudyGroupListDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import UIKit

final class MyStudyGroupListDIContainer: MyStudyGroupListCoordinatorDependencies {
    
    typealias Navigation = MyStudyGroupListNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    func makeMyStudyGroupListRepository() -> MyStudyGroupListRepository {
        DefaultMyStudyGroupListRepository(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository()
    }
    
    func makeDetailsudyActivityRepository() -> DetailStudyActivityRepository {
        // MARK: - TODO netwokring 후 Default로 교체
        MockDetailStudyActivityRepository()
    }
    
    func makeDetailActivityMemberRepository() -> DetailActivityMemberListRepository {
        MockDetailActivityMemberListRepository()
    }
    
    // MARK: - UseCase
    
    func makeMyStudyGroupListUseCase() -> MyStudyGroupListUseCase {
        DefaultMyStudyGroupListUseCase(repository: makeMyStudyGroupListRepository())
    }
    
    func makeStudyActivityUseCase() -> StudyActivityUseCase {
        DefaultStudyActivityUseCase(repository: makeStudyActivityRepository())
    }
    
    func makeDetailStudyActivityUseCase() -> DetailStudyActivityUseCase {
        DefaultDetailStudyActivityUseCase(repository: makeDetailsudyActivityRepository())
    }
    
    func makeDetailActivityPhotoListUseCase() -> DetailActivityPhotoListUseCase {
        DefualtDetailActivityPhotoListUseCase()
    }
    
    func makeDetailActivityMemberListUseCase() -> DetailActivityMemberListUseCase {
        DefualtDetailActivityMemberListUseCase(repository: makeDetailActivityMemberRepository())
    }
    
    // MARK: - MyStudyGroupList
    
    func makeMyStudyGroupListViewModel() -> MyStudyGroupListViewModel {
        MyStudyGroupListViewModel(useCase: makeMyStudyGroupListUseCase())
    }
    
    func makeMyStudyGroupListVC(coordinator: Navigation) -> MyStudyGroupListViewController {
        MyStudyGroupListViewController(
            coordinator:  coordinator,
            viewModel: makeMyStudyGroupListViewModel()
        )
    }
    
    // MARK: - StudyActivity
    
    func makeAllStudyActivityViewModel() -> AllStudyActivityViewModel {
        AllStudyActivityViewModel(useCase: makeStudyActivityUseCase())
    }
    
    func makeGroupStudyActivityViewModel() -> GroupStudyActivityViewModel {
        GroupStudyActivityViewModel(useCase: makeStudyActivityUseCase())
    }
    
    func makeTaskStudyActivityViewModel() -> TaskStudyActivityViewModel {
        TaskStudyActivityViewModel(useCase: makeStudyActivityUseCase())
    }
    
    func makePageViewControllers(coordinator: Navigation) -> [UIViewController] {
        return [
            AllStudyActivityViewController(
                viewModel: makeAllStudyActivityViewModel(),
                coordinator: coordinator),
            GroupStudyActivityViewController(
                viewModel: makeGroupStudyActivityViewModel(),
                coordinator: coordinator
            ),
            TaskStudyActivityViewController(
                viewModel: makeTaskStudyActivityViewModel(),
                coordinator: coordinator
            )
        ]
    }
    
    func makeStudyActivityVC(coordinator: MyStudyGroupListNavigation) -> StudyActivityViewController {
        StudyActivityViewController(
            viewControllers: makePageViewControllers(coordinator: coordinator),
            viewModel: StudyActivityViewModel(),
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
    
    func makeDetailActivityMemberListViewModel() -> DetailActivityMemberListViewModel {
        DetailActivityMemberListViewModel(useCase: makeDetailActivityMemberListUseCase())
    }
    
    func makeDetailActivityMemberListVC(coordinator: Navigation) -> DetailActivityMemberListViewController {
        DetailActivityMemberListViewController(
            coordinator: coordinator,
            viewModel: makeDetailActivityMemberListViewModel()
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
    
    func makeMyStudyGroupListCoordinator(navigationController: UINavigationController) -> MyStudyGroupListCoordinator {
        return MyStudyGroupListCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
