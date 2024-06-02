//
//  StudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

final class StudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapCreateButton: AnyPublisher<Void, Never>
        let didTapAllButton: AnyPublisher<Void, Never>
        let didTapGroupButton: AnyPublisher<Void, Never>
        let didTapTaskButton: AnyPublisher<Void, Never>
        let didTapXButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyActivityItem], Never>
        let isSelected: AnyPublisher<[Bool], Never>
        let presentToCreateActivityVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: StudyActivityUseCase
    
    // MARK: - Init
    
    init(useCase: StudyActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let initialItems = useCase.getActivityItems(type: .all(nil)).eraseToAnyPublisher()
        
        let allItems = input.didTapAllButton
            .map { (.all(nil)) }
            .flatMap(useCase.getActivityItems)
        
        let groupItems = input.didTapGroupButton
            .map { (.group(nil)) }
            .flatMap(useCase.getActivityItems)
        
        let taskItems = input.didTapTaskButton
            .map { (.task(nil)) }
            .flatMap(useCase.getActivityItems)
        
        let items = Publishers.Merge4(allItems, groupItems, taskItems, initialItems)
            .eraseToAnyPublisher()
        
        let isSelected = Publishers.Merge3(
            input.didTapAllButton.map { _ in [true, false, false] },
            input.didTapGroupButton.map { _ in [false, true, false] },
            input.didTapTaskButton.map { _ in [false, false, true] }
        )
            .eraseToAnyPublisher()
        
        let presentToCreateAcitivityVC = input.didTapCreateButton.eraseToAnyPublisher()
        
        return Output(
            items: items,
            isSelected: isSelected,
            presentToCreateActivityVC: presentToCreateAcitivityVC
        )
    }

}
