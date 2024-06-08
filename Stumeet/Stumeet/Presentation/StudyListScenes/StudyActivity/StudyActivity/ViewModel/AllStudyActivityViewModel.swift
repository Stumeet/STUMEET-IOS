//
//  StudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

final class AllStudyActivityViewModel: ViewModelType {
    
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
        
        let items = useCase.getActivityItems(type: .all(nil)).eraseToAnyPublisher()
        
        
        return Output(
            items: items
        )
    }

}
