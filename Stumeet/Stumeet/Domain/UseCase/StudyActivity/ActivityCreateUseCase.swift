//
//  CreateActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Combine
import Foundation

protocol CreateActivityUseCase {
    func setIsEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never>
    func setMaxLengthText(content: String) -> AnyPublisher<String, Never>
}

final class DefaultCreateActivityUseCase: CreateActivityUseCase {
    
    func setIsEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never> {
        return Just(!content.isEmpty && !title.isEmpty && content != "내용을 입력하세요").eraseToAnyPublisher()
    }
    
    func setMaxLengthText(content: String) -> AnyPublisher<String, Never> {
        let text = "!  활동 내용은 500자 이내로만 작성할 수 있어요."
        return Just(content.count > 500 ? text : "").eraseToAnyPublisher()
    }
}
