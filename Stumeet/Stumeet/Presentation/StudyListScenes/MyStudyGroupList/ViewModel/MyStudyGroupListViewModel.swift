//
//  MyStudyGroupListViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/03.
//

import Combine

final class MyStudyGroupListViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyGroupDataSource: AnyPublisher<[StudyGroup], Never>
    }
    
    // MARK: - Properties
    private var useCase: MyStudyGroupListUseCase
    
    // MARK: - Init
    init(useCase: MyStudyGroupListUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let studyGroupDataSource = input.viewWillAppear
            .flatMap {  [weak self] type -> AnyPublisher<[StudyGroup], Never> in
                guard let self = self
                else { return Empty().eraseToAnyPublisher() }
                return useCase.getStudyGroupItems(type: MyStudyGroupListType.active.description)
            }
            .map { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            studyGroupDataSource: studyGroupDataSource
        )
    }
}

