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
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyActivityItem], Never>
        let isSelected: AnyPublisher<[Bool], Never>
    }
    
    // MARK: - Properties
    
    let useCase: StudyActivityUseCase
    private var initialItems: AnyPublisher<[StudyActivityItem], Never> {
        useCase.getActivityItems(type: .all(nil))
            .eraseToAnyPublisher()
    }
    
    let didTapAllButton = PassthroughSubject<Void, Never>()
    let didTapGroupButton = PassthroughSubject<Void, Never>()
    let didTapTaskButton = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    init(useCase: StudyActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // 전체 활동 아이템
        let allItems = didTapAllButton
            .flatMap { [weak self] _ -> AnyPublisher<[StudyActivityItem], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.getActivityItems(type: .all(nil))
            }
        
        // 그룹 활동 아이템
        let groupItems = didTapGroupButton
            .flatMap { [weak self] _ -> AnyPublisher<[StudyActivityItem], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.getActivityItems(type: .group(nil))
            }
        
        // 과제 활동 아이템
        let taskItems = didTapTaskButton
            .flatMap { [weak self] _ -> AnyPublisher<[StudyActivityItem], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.getActivityItems(type: .task(nil))
            }
        
        // 최종 아이템
        let items = Publishers.Merge4(allItems, groupItems, taskItems, initialItems)
            .eraseToAnyPublisher()
        
        // 버튼 선택 상태
        let isSelected = Publishers.Merge3(
                didTapAllButton.map { _ in [true, false, false] },
                didTapGroupButton.map { _ in [false, true, false] },
                didTapTaskButton.map { _ in [false, false, true] }
            )
            .eraseToAnyPublisher()
        
        return Output(items: items, isSelected: isSelected)
    }

}
