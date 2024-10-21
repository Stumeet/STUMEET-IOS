//
//  CreateStudyGroupUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 7/31/24.
//

import Combine
import Foundation
import UIKit

protocol CreateStudyGroupUseCase {
    func getIsEnableTagAddButton(text: String) -> AnyPublisher<Bool, Never>
    func addTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never>
    func removeTag(tags: [String], newTag: String) -> AnyPublisher<[String], Never>
    func getCurrentDate() -> Date
    func downSampleImageData(url: URL) -> AnyPublisher<UIImage?, Never>
    func setTextFieldCount(text: String, maxCount: Int) -> AnyPublisher<Int, Never>
    func checkTextFieldLonggestThanMax(nickname: String, maxCount: Int) -> AnyPublisher<Bool, Never>
    func setTextViewText(placeholder: String) -> AnyPublisher<String?, Never>
    func getIsShowSnackBar(data: CreateStudyGroup) -> AnyPublisher<Bool, Never>
}

final class DefaultCreateStudyGroupUseCase: CreateStudyGroupUseCase {
    
    private let repository: CreateStudyGroupRepository
    
    init(repository: CreateStudyGroupRepository) {
        self.repository = repository
    }
    
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
    
    func downSampleImageData(url: URL) -> AnyPublisher<UIImage?, Never> {
        let targetSize = CGSize(width: 180, height: 180)
        let cgManager = CoreGraphicManager()
        let downsampledImageData = cgManager.downsample(imageAt: url, to: targetSize, scale: UIScreen.main.scale)
        
        return Just(downsampledImageData).eraseToAnyPublisher()
    }

    func checkTextFieldLonggestThanMax(nickname: String, maxCount: Int) -> AnyPublisher<Bool, Never> {
        return Just(nickname.count > maxCount).eraseToAnyPublisher()
    }
    
    func setTextFieldCount(text: String, maxCount: Int) -> AnyPublisher<Int, Never> {
        if text == "스터디를 소개해주세요." {
            return Just(0).eraseToAnyPublisher()
        }
        return Just(text.count > maxCount ? maxCount : text.count ).eraseToAnyPublisher()
    }
    
    func setTextViewText(placeholder: String) -> AnyPublisher<String?, Never> {
        var result: String? = ""
        if placeholder != "스터디를 소개해주세요." {
            result = nil
        }
        
        return Just(result).eraseToAnyPublisher()
    }
    
    func getIsShowSnackBar(data: CreateStudyGroup) -> AnyPublisher<Bool, Never> {
        if data.name.isEmpty || data.field.isEmpty || data.tags.isEmpty || data.region.isEmpty || data.startDate.isEmpty || data.endDate.isEmpty || data.repetType == nil || data.time == nil {
            return Just(true).eraseToAnyPublisher()
        } else {
            return repository.postCreateStudyGroup(data: data)
        }
    }
}
