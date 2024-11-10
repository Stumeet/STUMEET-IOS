//
//  AuthSceneDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/07.
//

import UIKit
import Moya

final class AuthSceneDIContainer: AuthCoordinatorDependencies {
    typealias Navigation = AuthNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
        let keychainManager: KeychainManageable
        let kakaoLoginService: LoginService
        let appleLoginService: LoginService
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases    
    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(
            kakaoLoginService: dependencies.kakaoLoginService,
            appleLoginService: dependencies.appleLoginService,
            repository: makeSnsLoginRepository(),
            keychainManager: dependencies.keychainManager
        )
    }
    
    func makeChangeProfileUseCase() -> ChangeProfileUseCase {
        DefaultChangeProfileUseCase()
    }
    
    func makeNicknameUseCase() -> NicknameUseCase {
        DefaultNicknameUseCase.init(
            repository: makeNicknameRepository()
        )
    }
    
    func makeSelectRegionUseCase() -> SelectRegionUseCase {
        DefaultSelectRegionUseCase.init(
            repository: makeRegionRepository()
        )
    }
    
    func makeSelectFieldUseCase() -> SelectFieldUseCase {
        DefaultSelectFieldUseCase.init(
            repository: makeSelectFieldRepository()
        )
    }
    
    func makeStartUseCase() -> StartUseCase {
        DefaultStartUseCase.init(
            repository: makeStartRepository()
        )
    }
    
    // MARK: - Repositories
    func makeSnsLoginRepository() -> LoginRepository {
        DefaultLoginRepository(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    func makeNicknameRepository() -> NicknameRepository {
        DefaultNicknameRepository(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    func makeRegionRepository() -> RegionRepository {
        DefaultRegionRepository()
    }
    
    func makeSelectFieldRepository() -> SelecteFieldRepository {
        DefaultSelectFieldRepository.init(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    func makeStartRepository() -> StartRepository {
        DefualtStartRepository.init(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    // MARK: - Onboarding
    func makeOnboardingViewController(coordinator: Navigation) -> OnboardingViewController {
        OnboardingViewController.init(
            viewModel: makeOnboardingViewModel(),
            coordinator: coordinator
        )
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel.init()
    }
    
    // MARK: - Sns Login
    func makeSnsLoginViewController(coordinator: Navigation) -> SnsLoginViewController {
        SnsLoginViewController.init(
            viewModel: makeSnsLoginViewModel(),
            coordinator: coordinator
        )
    }
    
    func makeSnsLoginViewModel() -> SnsLoginViewModel {
        SnsLoginViewModel.init(
            useCase: makeLoginUseCase()
        )
    }
    
    // MARK: - ChangeProfile
    func makeChangeProfileViewController(coordinator: Navigation) -> ChangeProfileViewController {
        ChangeProfileViewController.init(
            viewModel: makeChangeProfileViewModel(),
            coordinator: coordinator
        )
    }
    
    func makeChangeProfileViewModel() -> ChangeProfileViewModel {
        ChangeProfileViewModel.init(
            useCase: makeChangeProfileUseCase()
        )
    }

    // MARK: - Nickname
    func makeNicknameViewController(image: Data, coordinator: Navigation) -> NicknameViewController {
        NicknameViewController.init(
            viewModel: makeNicknameViewModel(image: image),
            coordinator: coordinator
        )
    }
    
    func makeNicknameViewModel(image: Data) -> NicknameViewModel {
        let register = Register(
            profileImage: image,
            nickname: nil,
            region: nil,
            field: nil)
        
        return NicknameViewModel.init(
            useCase: makeNicknameUseCase(),
            register: register
        )
    }
    
    // MARK: - Select Region
    func makeSelectRegionViewController(register: Register, coordinator: Navigation) -> SelectRegionViewController {
        SelectRegionViewController.init(
            viewModel: makeSelectRegionViewModel(register: register),
            coordinator: coordinator
        )
    }
    
    func makeSelectRegionViewModel(register: Register) -> SelectRegionViewModel {
        SelectRegionViewModel.init(
            useCase: makeSelectRegionUseCase(),
            register: register
        )
    }
    
    // MARK: - Select Field
    func makeSelectFieldViewController(register: Register, coordinator: Navigation) -> SelectFieldViewController {
        SelectFieldViewController.init(
            viewModel: makeSelectFieldViewModel(register: register),
            coordinator: coordinator
        )
        
    }
    
    func makeSelectFieldViewModel(register: Register) -> SelecteFieldViewModel {
        SelecteFieldViewModel.init(
            useCase: makeSelectFieldUseCase(),
            register: register
        )
    }
    
    // MARK: - Start
    func makeStartViewController(register: Register, coordinator: Navigation) -> StartViewController {
        StartViewController.init(
            viewModel: makeStartViewModel(register: register),
            coordinator: coordinator)
    }
    
    func makeStartViewModel(register: Register) -> StartViewModel {
        StartViewModel.init(
            useCase: makeStartUseCase(),
            register: register
        )
    }
    
    // MARK: - Flow Coordinators
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
