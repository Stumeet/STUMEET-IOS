//
//  DetailStudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

final class DetailStudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[DetailStudyActivitySectionItem], Never>
    }
    
    // MARK: - Properties
    
    private let useCase: DetailStudyActivityUseCase
    
    // MARK: - Init
    
    init(useCase: DetailStudyActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.setDetailActivityItem()
        
        return Output(
            items: items
        )
    }
}
