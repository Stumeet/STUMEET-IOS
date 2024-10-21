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
    
    func makeCheckAdminUseCase() -> CheckAdminUseCase {
        DefaultCheckAdminUseCase(repository: makeStudyMemberRepository())
    }
    
    func makeFetchStudyMemberDetailUseCase() -> FetchStudyMemberDetailUseCase {
        DefaultFetchStudyMemberDetailUseCase(repository: makeStudyMemberRepository())
    }
    
    // MARK: - StudyMember
    func makeStudyMemberViewModel(studyId: Int) -> StudyMemberViewModel {
        StudyMemberViewModel(
            studyMemberUseCase: makeStudyMemberUseCase(),
            checkAdminUseCase: makeCheckAdminUseCase(),
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
    func makeStudyMemberDetailModel(studyId: Int, studyMemberId: Int) -> StudyMemberDetailViewModel {
        StudyMemberDetailViewModel(
            fetchStudyMemberDetailUseCase: makeFetchStudyMemberDetailUseCase(),
            checkAdminUseCase: makeCheckAdminUseCase(),
            studyId: studyId,
            studyMemberId: studyMemberId
        )
    }
    
    func makeStudyMemberDetailVC(coordinator: Navigation, studyId: Int, studyMemberId: Int) -> StudyMemberDetailViewController {
        StudyMemberDetailViewController(
            coordinator: coordinator,
            viewModel: makeStudyMemberDetailModel(
                studyId: studyId,
                studyMemberId: studyMemberId
            )
        )
    }
    
    // MARK: - StudyMemberAchievement
    func makeStudyMemberAchievementVC(coordinator: Navigation) -> StudyMemberAchievementViewController {
        StudyMemberAchievementViewController(
            coordinator: coordinator
        )
    }
    
    // MARK: - StudyMemberMeetingDetail
    func makeStudyMemberMeetingDetailVC(coordinator: Navigation) -> StudyMemberMeetingDetailViewController {
        StudyMemberMeetingDetailViewController(
            coordinator: coordinator
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
