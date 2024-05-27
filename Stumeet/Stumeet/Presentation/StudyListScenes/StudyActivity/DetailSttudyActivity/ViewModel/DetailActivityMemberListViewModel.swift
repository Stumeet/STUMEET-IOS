//
//  DetailActivityMemberListViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

final class DetailActivityMemberListViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[DetailActivityMemberSectionItem], Never>
    }
    
    // MARK: - Properties
    
    private let useCase: DetailActivityMemberListUseCase
    
    // MARK: - Init
    
    init(useCase: DetailActivityMemberListUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.setMembers()
        
        return Output(
            items: items
        )
    }
}
