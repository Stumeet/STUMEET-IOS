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
        let didTapXButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[DetailActivityMemberSectionItem], Never>
        let dismiss: AnyPublisher<Void, Never>
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
        
        let dismiss = input.didTapXButton.eraseToAnyPublisher()
        
        return Output(
            items: items,
            dismiss: dismiss
        )
    }
}
