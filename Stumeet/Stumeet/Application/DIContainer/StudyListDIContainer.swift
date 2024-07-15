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
    
    func makeDetailsudyActivityRepository() -> DetailStudyActivityRepository {
        DefaultDetailStudyActivityRepository(provider: dependencies.provider.makeProvider())
    }
    
    func makeDetailActivityMemberRepository() -> DetailActivityMemberListRepository {
        DefaultDetailActivityMemberListRepository(provider: dependencies.provider.makeProvider())
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
    
    func makeDetailActivityMemberListUseCase() -> DetailActivityMemberListUseCase {
        DefualtDetailActivityMemberListUseCase(repository: makeDetailActivityMemberRepository())
    }
    
    // MARK: - StudyList
    
    func makeStudyListVC(coordinator: Navigation) -> StudyListViewController {
        StudyListViewController(coordinator: coordinator)
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
    
    func makeStudyActivityVC(coordinator: StudyListNavigation) -> StudyActivityViewController {
        StudyActivityViewController(
            viewControllers: makePageViewControllers(coordinator: coordinator),
            viewModel: StudyActivityViewModel(),
            coordinator: coordinator)
    }
    
    // MARK: - DetailStudyActivity
    
    func makeDetailStudyActivityViewModel(studyID: Int, activityID: Int) -> DetailStudyActivityViewModel {
        DetailStudyActivityViewModel(useCase: makeDetailStudyActivityUseCase(), studyID: studyID, activityID: activityID)
    }
    
    func makeDetailStudyActivityVC(coordinator: Navigation, studyID: Int, activityID: Int) -> DetailStudyActivityViewController {
        DetailStudyActivityViewController(
            coordinator: coordinator,
            viewModel: makeDetailStudyActivityViewModel(studyID: studyID, activityID: activityID)
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
    
    func makeDetailActivityMemberListViewModel(studyID: Int, activityID: Int) -> DetailActivityMemberListViewModel {
        DetailActivityMemberListViewModel(
            useCase: makeDetailActivityMemberListUseCase(),
            studyID: studyID,
            activityID: activityID
        )
    }
    
    func makeDetailActivityMemberListVC(coordinator: Navigation, studyID: Int, activityID: Int) -> DetailActivityMemberListViewController {
        DetailActivityMemberListViewController(
            coordinator: coordinator,
            viewModel: makeDetailActivityMemberListViewModel(studyID: studyID, activityID: activityID)
        )
    }
    
    // MARK: - DIContainer
    func makeCreateActivityDIContainer() -> CreateActivityDIContainer {
        let dependencies = CreateActivityDIContainer.Dependencies(provider: dependencies.provider)
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
