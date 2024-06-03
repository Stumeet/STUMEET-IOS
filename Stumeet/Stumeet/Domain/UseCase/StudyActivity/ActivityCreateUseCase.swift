//
//  CreateActivityUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Combine
import Foundation

protocol CreateActivityUseCase {
    func setEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never>
    func setIsShowMaxLengthAlert(content: String) -> AnyPublisher<Bool, Never>
}

final class DefaultCreateActivityUseCase: CreateActivityUseCase {
    
    func setEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never> {
        return Just(!content.isEmpty && !title.isEmpty).eraseToAnyPublisher()
    }
    
    func setIsShowMaxLengthAlert(content: String) -> AnyPublisher<Bool, Never> {
        return Just(content.count > 500).eraseToAnyPublisher()
    }
}
