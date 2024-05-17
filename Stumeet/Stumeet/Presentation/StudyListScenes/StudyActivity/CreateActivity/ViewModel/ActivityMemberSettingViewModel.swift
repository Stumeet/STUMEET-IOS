//
//  ActivityMemberSettingViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/17/24.
//

import Combine
import Foundation

final class ActivityMemberSettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
    }
    
    // MARK: - Output
    
    struct Output {
        let members: AnyPublisher<[String], Never>
    }
    
    // MARK: - Properites
    
    private let useCase: ActivityMemberSettingUseCase
    
    // MARK: - Init
    
    init(useCase: ActivityMemberSettingUseCase) {
        self.useCase = useCase
    }
    
    
    func transform(input: Input) -> Output {
        let members = useCase.getMembers()
        
        return Output(
            members: members
        )
    }
    
}
