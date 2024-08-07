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
        let loadStudyGroupData: AnyPublisher<String, Never>
        let didSelectedCell: AnyPublisher<IndexPath, Never>
        let didTapCreateStudyButton: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyGroupDataSource: AnyPublisher<[StudyGroup], Never>
        let navigateToStudyMainVC: AnyPublisher<Int, Never>
        let presentToCreateStudyGroupVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    private var useCase: MyStudyGroupListUseCase
    private var studyGroupItemsSubject = CurrentValueSubject<[StudyGroup], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(useCase: MyStudyGroupListUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let studyGroupDataSource = studyGroupItemsSubject.eraseToAnyPublisher()
        
        let navigateToStudyMainVC = input.didSelectedCell
            .compactMap(studyGroupId(for:))
            .eraseToAnyPublisher()
        
        input.loadStudyGroupData
            .flatMap(useCase.getStudyGroupItems)
            .sink(receiveValue: studyGroupItemsSubject.send)
            .store(in: &cancellables)
    
        return Output(
            studyGroupDataSource: studyGroupDataSource,
            navigateToStudyMainVC: navigateToStudyMainVC,
            presentToCreateStudyGroupVC: input.didTapCreateStudyButton
        )
    }
    
    // MARK: - Function
    private func studyGroupId(for indexPath: IndexPath) -> Int? {
        return studyGroupItemsSubject.value[safe: indexPath.row]?.id
    }
}
