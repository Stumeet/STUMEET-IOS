//
//  CreateStudyGroupViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

final class CreateStudyGroupViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapFieldButton: AnyPublisher<Void, Never>
        let didSelectedField: AnyPublisher<StudyField, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let goToSelectStudyGroupFieldVC: AnyPublisher<Void, Never>
        let selectedField: AnyPublisher<StudyField, Never>
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(
            goToSelectStudyGroupFieldVC: input.didTapFieldButton,
            selectedField: input.didSelectedField
        )
    }
}
