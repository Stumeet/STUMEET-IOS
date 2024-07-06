//
//  CreateActivityDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import UIKit
import PhotosUI

final class CreateActivityDIContainer: CreateActivityCoordinatorDependencies {
    
    typealias Navigation = CreateActivityNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeStudyActivityUseCase() -> StudyActivityUseCase {
        DefaultStudyActivityUseCase.init(
            repository: makeStudyActivityRepository()
        )
    }
    
    func makeCreateActivityUseCase() -> CreateActivityUseCase {
        DefaultCreateActivityUseCase()
    }
    
    func makeBottomSheetCalendarUseCase() -> BottomSheetCalendarUseCase {
        DefaultBottomSheetCalendarUseCase()
    }
    
    func makeActivityMemeberSettingUseCase() -> ActivityMemberSettingUseCase {
        DefaultActivityMemberSettingUseCase(repository: makeActivityMemeberSettingRepository())
    }
    
    func makeStudyActivitySettingUseCase() -> StudyActivitySettingUseCase {
        DefaultStudyActivitySettingUseCase(repository: makeStudyActivitySettingRepository())
    }
    
    // MARK: - Repositories
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository(provider: dependencies.provider.makeProvider())
    }
    
    func makeActivityMemeberSettingRepository() -> ActivityMemberSettingRepository {
        DefaultActivityMemberSettingRepository(provider: dependencies.provider.makeProvider())
    }
    
    func makeStudyActivitySettingRepository() -> StudyActivitySettingRepository {
        DefaultStudyActivitySettingRepository(provider: dependencies.provider.makeProvider())
    }
    
    // MARK: - CreateActivity
    func makeCreateActivityViewModel() -> CreateActivityViewModel {
        CreateActivityViewModel(useCase: makeCreateActivityUseCase())
    }
    
    func makeCreateActivityViewController(coordinator: Navigation) -> CreateActivityViewController {
        CreateActivityViewController(
            viewModel: makeCreateActivityViewModel(),
            coordinator: coordinator
        )
    }
    
    // MARK: - StudyActivitySetting
    
    func makeStudyActivitySettingViewModel(activity: CreateActivity) -> StudyActivitySettingViewModel {
        StudyActivitySettingViewModel(
            activity: activity,
            useCase: makeStudyActivitySettingUseCase()
        )
    }
    
    func makeStudyActivitySettingViewController(activity: CreateActivity, coordinator: Navigation) -> StudyActivitySettingViewController {
        StudyActivitySettingViewController(
            viewModel: makeStudyActivitySettingViewModel(activity: activity),
            coordinator: coordinator
        )
    }
    
    // MARK: - BottomSheetCalendar
    
    func makeBottomSheetCalendarViewModel(isStart: Bool) -> BottomSheetCalendarViewModel {
        BottomSheetCalendarViewModel(useCase: makeBottomSheetCalendarUseCase(), isStart: isStart)
    }
    
    func makeBottomSheetCalendarViewController(coordinator: Navigation, isStart: Bool) -> BottomSheetCalendarViewController {
        BottomSheetCalendarViewController(
            viewModel: makeBottomSheetCalendarViewModel(isStart: isStart),
            coordinator: coordinator
        )
    }
    
    // MARK: - Member
    
    func makeActivityMemberSettingViewModel(member: [ActivityMember]) -> ActivityMemberSettingViewModel {
        ActivityMemberSettingViewModel(members: member, useCase: makeActivityMemeberSettingUseCase())
    }
    
    func makeActivityMemberSettingViewController(member: [ActivityMember], coordinator: Navigation) -> ActivityMemberSettingViewController {
        ActivityMemberSettingViewController(
            coordinator: coordinator,
            viewModel: makeActivityMemberSettingViewModel(member: member)
        )
    }
    
    // MARK: - LinkPopUp
    
    func makeCreateActivityLinkPopUpViewModel() -> CreateActivityLinkPopUpViewModel {
        CreateActivityLinkPopUpViewModel()
    }
    
    func makeCreateActivityLinkPopUpViewController(coordinator: Navigation) -> CreateActivityLinkPopUpViewController {
        CreateActivityLinkPopUpViewController(
            viewModel: makeCreateActivityLinkPopUpViewModel(),
            coordinator: coordinator
        )
    }
    
    // MARK: - Place
    
    func makeActivitPlaceSettingViewModel() -> ActivityPlaceSettingViewModel {
        ActivityPlaceSettingViewModel()
    }
    
    func makeActivityPlaceSettingViewController(coordinator: Navigation) -> ActivityPlaceSettingViewController {
        ActivityPlaceSettingViewController(
            viewModel: makeActivitPlaceSettingViewModel(),
            coordinator: coordinator
        )
    }
    
    // MARK: - PHPicker
    func makePHPickerViewController() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        let pickerVC = PHPickerViewController(configuration: config)
        
        return pickerVC
    }
}
