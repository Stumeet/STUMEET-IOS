//
//  CreateStudyGroupUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 7/31/24.
//

import Combine
import Foundation

protocol CreateStudyGroupUseCase {
    func getIsEnableTagAddButton(text: String) -> AnyPublisher<Bool, Never>
}

final class DefaultCreateStudyGroupUseCase: CreateStudyGroupUseCase {
    
    func getIsEnableTagAddButton(text: String) -> AnyPublisher<Bool, Never> {
        return Just(!text.isEmpty).eraseToAnyPublisher()
    }
}
