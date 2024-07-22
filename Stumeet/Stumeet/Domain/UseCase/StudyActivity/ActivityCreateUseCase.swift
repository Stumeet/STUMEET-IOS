//
//  CreateActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Combine
import UIKit

protocol CreateActivityUseCase {
    func setIsEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never>
    func setMaxLengthText(content: String) -> AnyPublisher<String, Never>
    func deletePhoto(selectedImage: UIImage, images: [UIImage]) -> AnyPublisher<[UIImage], Never>
    func postActivity(data: CreateActivity) -> AnyPublisher<Bool, Never>
}

final class DefaultCreateActivityUseCase: CreateActivityUseCase {
    
    private let repository: StudyActivitySettingRepository
    
    init(repository: StudyActivitySettingRepository) {
        self.repository = repository
    }
    
    func setIsEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never> {
        return Just(!content.isEmpty && !title.isEmpty && content != "내용을 입력하세요").eraseToAnyPublisher()
    }
    
    func setMaxLengthText(content: String) -> AnyPublisher<String, Never> {
        let text = "!  활동 내용은 500자 이내로만 작성할 수 있어요."
        return Just(content.count > 500 ? text : "").eraseToAnyPublisher()
    }
    
    func deletePhoto(selectedImage: UIImage, images: [UIImage]) -> AnyPublisher<[UIImage], Never> {
        var deletedImages = images
        deletedImages.removeAll(where: { $0 == selectedImage })
        return Just(deletedImages).eraseToAnyPublisher()
    }
    
    
    func postActivity(data: CreateActivity) -> AnyPublisher<Bool, Never> {
        return repository.postStudyActivity(activity: data)
    }
}
