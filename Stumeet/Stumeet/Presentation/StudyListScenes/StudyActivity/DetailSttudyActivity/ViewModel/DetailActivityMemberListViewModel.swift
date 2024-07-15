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
        let memberCount: AnyPublisher<String?, Never>
        let dismiss: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: DetailActivityMemberListUseCase
    private let studyID: Int
    private let activityID: Int
    
    // MARK: - Init
    
    init(useCase: DetailActivityMemberListUseCase, studyID: Int, activityID: Int) {
        self.useCase = useCase
        self.studyID = studyID
        self.activityID = activityID
    }

    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.getMembers(studyID: studyID, activityID: activityID)
        
        let memberCount = items
            .flatMap(useCase.getMemberCount)
            .eraseToAnyPublisher()
        
        let dismiss = input.didTapXButton.eraseToAnyPublisher()
        
        return Output(
            items: items,
            memberCount: memberCount,
            dismiss: dismiss
        )
    }
}
