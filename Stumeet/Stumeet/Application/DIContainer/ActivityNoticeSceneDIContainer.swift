//
//  ActivityNoticeSceneDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import UIKit
import Moya

final class ActivityNoticeSceneDIContainer: ActivityNoticeCoordinatorDependencies {
    typealias Navigation = ActivityNoticeNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    func makeStudyGroupMainRepository() -> StudyGroupMainRepository {
        DefaultStudyGroupMainRepository(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository(provider: dependencies.provider.makeProvider())
    }
    
    // MARK: - Use Cases
    func makeFetchLatestNoticeUseCase() -> FetchLatestNoticeUseCase {
        DefaultFetchLatestNoticeUseCase(
            repository: makeStudyActivityRepository()
        )
    }
    
    func makeFetchNoticesUseCase() -> FetchNoticesUseCase {
        DefaultFetchNoticesUseCase(
            repository: makeStudyActivityRepository()
        )
    }
    
    // MARK: - ActivityNotice
    func makeActivityNoticeViewModel(studyId: Int) -> ActivityNoticeViewModel {
        ActivityNoticeViewModel(
            fetchLatestNoticeUseCase: makeFetchLatestNoticeUseCase(),
            fetchNoticesUseCase: makeFetchNoticesUseCase(),
            studyID: studyId
        )
    }
    
    func makeActivityNoticeVC(coordinator: Navigation, studyId: Int) -> ActivityNoticeViewController {
        ActivityNoticeViewController(
            coordinator: coordinator,
            viewModel: makeActivityNoticeViewModel(studyId: studyId)
        )
    }
    
    // MARK: - Flow Coordinators
    func makeActivityNoticeCoordinator(navigationController: UINavigationController, studyId: Int) -> ActivityNoticeCoordinator {
        ActivityNoticeCoordinator(
            navigationController: navigationController,
            dependencies: self,
            studyId: studyId
        )
    }
}
