//
//  StudyMemberSceneDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/27.
//

import UIKit
import Moya

final class StudyMemberSceneDIContainer: StudyMemberCoordinatorDependencies {
    typealias Navigation = StudyMemberNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    func makeStudyMemberRepository() -> StudyMemberRepository {
        DefaultStudyMemberRepository(provider: dependencies.provider.makeProvider())
    }
    
    // MARK: - Use Cases
    func makeStudyMemberUseCase() -> StudyMemberUseCase {
        DefaultStudyMemberUseCase(repository: makeStudyMemberRepository())
    }
    
    // MARK: - StudyMember
    func makeStudyMemberViewModel(studyId: Int) -> StudyMemberViewModel {
        StudyMemberViewModel(
            useCase: makeStudyMemberUseCase(),
            studyId: studyId
        )
    }
    
    func makeStudyMemberVC(coordinator: Navigation, studyId: Int) -> StudyMemberViewController {
        StudyMemberViewController(
            coordinator: coordinator,
            viewModel: makeStudyMemberViewModel(studyId: studyId)
        )
    }
    
    // MARK: - StudyMemberDetail
    func makeStudyMemberDetailModel() -> StudyMemberDetailViewModel {
        StudyMemberDetailViewModel()
    }
    
    func makeStudyMemberDetailVC(coordinator: Navigation) -> StudyMemberDetailViewController {
        StudyMemberDetailViewController(
            coordinator: coordinator,
            viewModel: makeStudyMemberDetailModel()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeStudyMemberCoordinator(navigationController: UINavigationController, studyId: Int) -> StudyMemberCoordinator {
        StudyMemberCoordinator(
            navigationController: navigationController,
            dependencies: self,
            studyId: studyId
        )
    }
}
