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
    
    // MARK: - UseCase
    
    func makeSelectStudyGroupItemUseCase() -> SelectStudyGroupItemUseCase {
        DefaultSelectStudyItemUseCase(repository: makeSelectStudyGroupItemRepository())
    }
    
    func makeCreateStudyGroupUseCase() -> CreateStudyGroupUseCase {
        DefaultCreateStudyGroupUseCase()
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
    
    func makeSetStudyGroupPeriodVC(coordinator: CreateStudyGroupNavigation) -> SetStudyGroupPeriodViewController  {
        SetStudyGroupPeriodViewController()
    }
    
    
}
