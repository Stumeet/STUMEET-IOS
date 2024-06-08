//
//  CreateActivityDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 5/10/24.
//

import UIKit

final class CreateActivityDIContainer: CreateActivityCoordinatorDependencies {
    
    typealias Navigation = CreateActivityNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider?
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
    
    // MARK: - Repositories
    func makeStudyActivityRepository() -> StudyActivityRepository {
        DefaultStudyActivityRepository()
    }
    
    func makeActivityMemeberSettingRepository() -> ActivityMemberSettingRepository {
        DefaultActivityMemberSettingRepository()
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
    
    func makeStudyActivitySettingViewModel() -> StudyActivitySettingViewModel {
        StudyActivitySettingViewModel()
    }
    
    func makeStudyActivitySettingViewController(coordinator: Navigation) -> StudyActivitySettingViewController {
        StudyActivitySettingViewController(
            viewModel: makeStudyActivitySettingViewModel(),
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
    
    func makeActivityMemberSettingViewModel() -> ActivityMemberSettingViewModel {
        ActivityMemberSettingViewModel(useCase: makeActivityMemeberSettingUseCase())
    }
    
    func makeActivityMemberSettingViewController(coordinator: Navigation) -> ActivityMemberSettingViewController {
        ActivityMemberSettingViewController(
            coordinator: coordinator,
            viewModel: makeActivityMemberSettingViewModel()
        )
    }
    
}
