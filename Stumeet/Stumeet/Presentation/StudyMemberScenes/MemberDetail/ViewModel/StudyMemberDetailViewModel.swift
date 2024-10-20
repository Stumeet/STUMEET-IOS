//
//  StudyMemberDetailViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/02.
//

import Combine
import Foundation

final class StudyMemberDetailViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
    }

    // MARK: - Output
    struct Output {
    }
    
    // MARK: - Properties
    private var studyId: Int
    private var studyMemberId: Int
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        studyId: Int,
        studyMemberId: Int
    ) {
        self.studyId = studyId
        self.studyMemberId = studyMemberId
    }
    
    func transform(input: Input) -> Output {
    
        return Output(
        )
    }
    
    // MARK: - Function
}
