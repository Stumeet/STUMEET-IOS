//
//  CreateStudyGroupDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 7/24/24.
//

import Foundation

final class CreateStudyGroupDIContainer: CreateStudyGroupCoordinatorDependencies {
    
    typealias Navigation = MyStudyGroupListNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    func makeSelectStudyGroupItemRepository() -> SelectStudyGroupItemRepository {
        DefaultSelectStudyGroupItemRepository()
    }
    
    func makeSetStudyGroupPeriodRepository() -> SetStudyGroupPeriodRepository {
        DefaultSetStudyGroupPeriodRepository()
    }
    
    func makeMonthlyDaysRepository() -> MonthlyDaysRepository {
        DefaultMonthlyDaysRepository()
    }
    
    func makeCreateStudyGroupRepository() -> CreateStudyGroupRepository {
        DefaultCreateStudyGroupRepository(
            provider: dependencies.provider.makeProvider()
        )
    }
    
    // MARK: - UseCase
    
    func makeSelectStudyGroupItemUseCase() -> SelectStudyGroupItemUseCase {
        DefaultSelectStudyItemUseCase(repository: makeSelectStudyGroupItemRepository())
    }
    
    func makeCreateStudyGroupUseCase() -> CreateStudyGroupUseCase {
        DefaultCreateStudyGroupUseCase(repository: makeCreateStudyGroupRepository())
    }
    
    func makeSetStudyGroupPeriodUseCase() -> SetStudyGroupPeriodUseCase {
        DefaultSetStudyGroupPeriodUseCase(repository: makeSetStudyGroupPeriodRepository())
    }
    
    func makeSelectStudyTimeUseCase() -> SelectStudyTimeUseCase {
        DefaultSelectStudyTimeUseCase()
    }
    
    func makeSelectStudyRepeatUseCase() -> SelectStudyRepeatUseCase {
        DefaultSelectStudyRepeatUseCase(repository: makeMonthlyDaysRepository())
    }
    
    // MARK: - CreateStudyGroupVC
    
    func makeCreteStudyGroupVM() -> CreateStudyGroupViewModel {
        CreateStudyGroupViewModel(useCase: makeCreateStudyGroupUseCase())
    }
    
    func makeCreateStudyGroupVC(coordinator: CreateStudyGroupNavigation) -> CreateStudyGroupViewController {
        CreateStudyGroupViewController(
            coordinator: coordinator,
            viewModel: makeCreteStudyGroupVM()
        )
    }
    
    // MARK: - SelectStudyGroupItem
    
    func makeSelectStudyGroupItemVM(type: CreateStudySelectItemType) -> SelectStudyItemViewModel {
        SelectStudyItemViewModel(
            useCase: makeSelectStudyGroupItemUseCase(),
            type: type
        )
    }
    
    func makeSelectStudyGroupItemVC(coordinator: CreateStudyGroupNavigation, type: CreateStudySelectItemType) -> SelectStudyGroupItemViewController {
        SelectStudyGroupItemViewController(
            coordinator: coordinator,
            viewModel: makeSelectStudyGroupItemVM(type: type)
        )
    }
    
    // MARK: - SetStudyGroupPeriod
    
    func makeSetStudyGroupPeriodVM(dates: (isStart: Bool, startDate: Date, endDate: Date?)) -> SetStudyGroupPeriodViewModel {
        SetStudyGroupPeriodViewModel(
            useCase: makeSetStudyGroupPeriodUseCase(),
            dates: dates
        )
    }
    
    func makeSetStudyGroupPeriodVC(coordinator: CreateStudyGroupNavigation, dates: (isStart: Bool, startDate: Date, endDate: Date?)) -> SetStudyGroupPeriodViewController  {
        SetStudyGroupPeriodViewController(
            coordinator: coordinator,
            viewModel: makeSetStudyGroupPeriodVM(dates: dates)
        )
    }
    
    // MARK: - SelectStudyTime
    
    func makeSelectStudyTimeVM() -> SelectStudyTimeViewModel {
        SelectStudyTimeViewModel(
            useCase: makeSelectStudyTimeUseCase()
        )
    }
    
    func makeSelectStudyTimeVC(coordinator: CreateStudyGroupNavigation) -> SelectStudyTimeViewController {
        SelectStudyTimeViewController(
            coordinator: coordinator,
            viewModel: makeSelectStudyTimeVM()
        )
    }
    
    // MARK: - SelectStudyRepeat
    
    func makeSelectStudyRepeatVM() -> SelectStudyRepeatViewModel {
        SelectStudyRepeatViewModel(useCase: makeSelectStudyRepeatUseCase())
    }
    
    func makeSelectStudyRepeatVC(coordinator: CreateStudyGroupNavigation) -> SelectStudyRepeatViewController {
        SelectStudyRepeatViewController(
            coordinator: coordinator,
            viewModel: makeSelectStudyRepeatVM()
        )
    }
}
