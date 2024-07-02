//
//  GroupStudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import Combine
import Foundation

final class GroupStudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyActivitySectionItem], Never>
    }
    
    // MARK: - Properties
    
     private let useCase: StudyActivityUseCase
    
    // MARK: - Init
    
    init(useCase: StudyActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.getActivityItems(type: .group(nil))
            .map { $0.map { StudyActivitySectionItem.group($0) } }
            .eraseToAnyPublisher()
        
        
        return Output(
            items: items
        )
    }
}
