//
//  MyStudyGroupListViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/03.
//

import Combine
import Foundation

final class MyStudyGroupListViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
        let didSelectedCell: AnyPublisher<IndexPath, Never>
    }

    // MARK: - Output
    struct Output {
        let studyGroupDataSource: AnyPublisher<[StudyGroup], Never>
        let navigateToStudyMainVC: AnyPublisher<Int?, Never>
    }
    
    // MARK: - Properties
    private var useCase: MyStudyGroupListUseCase
    private var studyGroupData: [StudyGroup] = []
    
    // MARK: - Init
    init(useCase: MyStudyGroupListUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let studyGroupDataSource = input.viewWillAppear
            .flatMap { [weak self] type -> AnyPublisher<[StudyGroup], Never> in
                guard let self = self
                else { return Empty().eraseToAnyPublisher() }
                return useCase.getStudyGroupItems(type: MyStudyGroupListType.active.description)
            }
            .map { [weak self] data -> [StudyGroup] in
                guard let self = self else { return [] }
                studyGroupData = data
                return studyGroupData
            }
            .eraseToAnyPublisher()
        
        let navigateToStudyMainVC = input.didSelectedCell
            .map { [weak self] index -> Int? in
                guard let self = self,
                      let studyGroup = studyGroupData[safe: index.row]
                else { return nil }

                return studyGroup.id
            }
            .eraseToAnyPublisher()
        
        return Output(
            studyGroupDataSource: studyGroupDataSource,
            navigateToStudyMainVC: navigateToStudyMainVC
        )
    }
}
