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
    func addTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never>
}

final class DefaultCreateStudyGroupUseCase: CreateStudyGroupUseCase {
    
    func getIsEnableTagAddButton(text: String) -> AnyPublisher<Bool, Never> {
        return Just(!text.isEmpty).eraseToAnyPublisher()
    }
    
    func addTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never> {
        var updatedTags = tags
        if !updatedTags.contains(where: { $0 == newTag }) {
            updatedTags.append(newTag)
        }
        return Just(updatedTags).eraseToAnyPublisher()
    }
}
