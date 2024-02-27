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
        
        let allItems = didTapAllButton
            .flatMap { [weak self] _ -> AnyPublisher<[StudyActivityItem], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.getActivityItems(type: .all(nil))
            }
        
        let groupItems = didTapGroupButton
            .flatMap { [weak self] _ -> AnyPublisher<[StudyActivityItem], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.getActivityItems(type: .group(nil))
            }
        
        let taskItems = didTapTaskButton
            .flatMap { [weak self] _ -> AnyPublisher<[StudyActivityItem], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.getActivityItems(type: .task(nil))
            }
        
        let items = Publishers.Merge4(allItems, groupItems, taskItems, initialItems)
            .eraseToAnyPublisher()
        
        return Output(items: items)
    }

}
