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
        let items: AnyPublisher<[ActivityMemberSectionItem], Never>
    }
    
    // MARK: - Properties
    
    private let names: [String]
    
    // MARK: - Init
    
    init(names: [String]) {
        self.names = names
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        let items = Just(names.map { ActivityMemberSectionItem.memberCell($0, false) }).eraseToAnyPublisher()
        return Output(
            items: items
        )
    }
}
