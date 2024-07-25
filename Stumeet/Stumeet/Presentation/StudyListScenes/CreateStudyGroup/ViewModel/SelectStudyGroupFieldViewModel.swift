//
//  SelectStudyGroupFieldViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//


import Combine
import Foundation

final class SelectStudyGroupFieldViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyFieldSectionItem], Never>
    }
    
    // MARK: - Properties
    
    private let useCase: SelectStudyGroupFieldUseCase
    
    
    // MARK: - Init
    
    init(useCase: SelectStudyGroupFieldUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.getFieldItems()
            .map { $0.map { StudyFieldSectionItem.fieldCell($0) } }
            .eraseToAnyPublisher()
        
        return Output(
            items: items
        )
    }
}
