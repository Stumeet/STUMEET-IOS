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
    
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository(provider: dependencies.provider.makeProvider())
    }
    
    func makeDetailActivityMemberListRepository() -> DetailActivityMemberListRepository {
        DefaultDetailActivityMemberListRepository(provider: dependencies.provider.makeProvider())
    }
    
    func makeDetailStudyActivityRepository() -> DetailStudyActivityRepository {
        DefaultDetailStudyActivityRepository(provider: dependencies.provider.makeProvider())
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
    
    func makeFetchStudyMemberActivityUseCase() -> FetchStudyMemberActivityUseCase {
        DefaultFetchStudyMemberActivityUseCase(repository: makeStudyActivityRepository())
    }
    
    func makeKickOutStudyMemberUseCase() -> KickOutStudyMemberUseCase {
        DefaultKickOutStudyMemberUseCase(repository: makeStudyMemberRepository())
    }
    
    func makeDelegateStudyAdminUseCase() -> DelegateStudyAdminUseCase {
        DefaultDelegateStudyAdminUseCase(repository: makeStudyMemberRepository())
    }
    
    func makeFetchAllStudyActivitiesUseCase() -> FetchAllStudyActivitiesUseCase {
        DefaultFetchAllStudyActivitiesUseCase(repository: makeStudyActivityRepository())
    }
    
    func makeFetchActiveStudyMembersUseCase() -> FetchActiveStudyMembersUseCase {
        DefaultFetchActiveStudyMembersUseCase(repository: makeDetailActivityMemberListRepository())
    }
    
    func makeDetailStudyActivityUseCase() -> DetailStudyActivityUseCase {
        DefaultDetailStudyActivityUseCase(repository: makeDetailStudyActivityRepository())
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
    func makeStudyMemberDetailViewModel(studyId: Int, studyMemberId: Int) -> StudyMemberDetailViewModel {
        StudyMemberDetailViewModel(
            fetchStudyMemberDetailUseCase: makeFetchStudyMemberDetailUseCase(),
            fetchStudyMemberActivityUseCase: makeFetchStudyMemberActivityUseCase(),
            checkAdminUseCase: makeCheckAdminUseCase(),
            kickOutStudyMemberUseCase: makeKickOutStudyMemberUseCase(),
            delegateStudyAdminUseCase: makeDelegateStudyAdminUseCase(),
            studyId: studyId,
            studyMemberId: studyMemberId
        )
    }
    
    func makeStudyMemberDetailVC(coordinator: Navigation, studyId: Int, studyMemberId: Int) -> StudyMemberDetailViewController {
        StudyMemberDetailViewController(
            coordinator: coordinator,
            viewModel: makeStudyMemberDetailViewModel(
                studyId: studyId,
                studyMemberId: studyMemberId
            )
        )
    }
    
    // MARK: - StudyMemberAchievement
    func makeStudyMemberAchievementViewModel(studyId: Int) -> StudyMemberAchievementViewModel {
        StudyMemberAchievementViewModel(
            fetchAllStudyActivitiesUseCase: makeFetchAllStudyActivitiesUseCase(),
            studyId: studyId
        )
    }
    
    func makeStudyMemberAchievementVC(coordinator: Navigation, studyId: Int) -> StudyMemberAchievementViewController {
        StudyMemberAchievementViewController(
            coordinator: coordinator,
            viewModel: makeStudyMemberAchievementViewModel(studyId: studyId)
        )
    }
    
    // MARK: - StudyMemberMeetingDetail
    func makeStudyMemberActivityDetailViewModel(studyID: Int, activityID: Int) -> StudyMemberActivityDetailViewModel {
        StudyMemberActivityDetailViewModel(
            fetchActiveStudyMembersUseCase: makeFetchActiveStudyMembersUseCase(),
            detailStudyActivityUseCase: makeDetailStudyActivityUseCase(),
            studyID: studyID,
            activityID: activityID
        )
    }
    
    func makeStudyMemberActivityDetailVC(
        coordinator: Navigation,
        studyID: Int,
        activityID: Int
    ) -> StudyMemberActivityDetailViewController {
        StudyMemberActivityDetailViewController(
            coordinator: coordinator,
            viewModel: makeStudyMemberActivityDetailViewModel(studyID: studyID, activityID: activityID)
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
