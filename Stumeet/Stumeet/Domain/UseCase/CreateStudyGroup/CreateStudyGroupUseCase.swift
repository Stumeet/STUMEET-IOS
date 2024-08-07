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
    func removeTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never>
    func getCurrentDate() -> Date
}

final class DefaultCreateStudyGroupUseCase: CreateStudyGroupUseCase {
    
    func getIsEnableTagAddButton(text: String) -> AnyPublisher<Bool, Never> {
        return Just(!text.isEmpty).eraseToAnyPublisher()
    }
    
    func addTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never> {
        var updatedTags = tags
        if !updatedTags.contains(where: { $0 == newTag }) && updatedTags.count < 5 {
            updatedTags.append(newTag)
        }
        return Just(updatedTags).eraseToAnyPublisher()
    }
    
    func removeTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never> {
        var removedTags = tags
        removedTags.removeAll(where: { $0 == newTag })
        return Just(removedTags).eraseToAnyPublisher()
    }
    
    func getCurrentDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        let date = Date()
        let formattedDate = dateFormatter.string(from: date)
        return dateFormatter.date(from: formattedDate)!
    }

}
