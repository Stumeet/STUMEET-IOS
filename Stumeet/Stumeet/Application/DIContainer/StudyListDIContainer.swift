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
    
    // MARK: - UseCase
    func makeStudyActivityUseCase() -> StudyActivityUseCase {
        DefaultStudyActivityUseCase(repository: makeStudyActivityRepository())
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
}
