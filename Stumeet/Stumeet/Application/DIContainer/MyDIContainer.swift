//
//  MyDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import UIKit

final class MyDIContainer: MyCoordinatorDependencies {
    
    typealias Navigation = MyNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    func makeUserRepository() -> UserRepository {
        DefaultUserRepository(provider: dependencies.provider.makeProvider())
    }
    
    func makeMemberReviewRepository() -> MemberReviewRepository {
        DefaultMemberReviewRepository(provider: dependencies.provider.makeProvider())
    }
    
    // MARK: - UseCase
    func makeFetchMemberReviewTagStatsUseCase() -> FetchMemberReviewTagStatsUseCase {
        DefaultFetchMemberReviewTagStatsUseCase(
            repository: makeMemberReviewRepository()
        )
    }
    
    func makeFetchMyProfileUseCase() -> FetchMyProfileUseCase {
        DefaultFetchMyProfileUseCase(
            repository: makeUserRepository()
        )
    }
 
    // MARK: - My
    func makeMyViewModel() -> MyViewModel {
        MyViewModel(
            fetchMyProfileUseCase: makeFetchMyProfileUseCase(),
            fetchMemberReviewTagStatsUseCase: makeFetchMemberReviewTagStatsUseCase()
        )
    }
    
    func makeMyVC(coordinator: MyNavigation) -> MyViewController {
        MyViewController(
            coordinator: coordinator,
            viewModel: makeMyViewModel()
        )
    }
    
    // MARK: - Flow Coordinators
    func makeMyCoordinator(navigationController: UINavigationController) -> MyCoordinator {
        return MyCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
   
    // MARK: - DIContainers of scenes
}
