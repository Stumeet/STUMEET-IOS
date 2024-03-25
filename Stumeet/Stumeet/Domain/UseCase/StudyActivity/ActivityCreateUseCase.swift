//
//  ActivityCreateUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Combine
import Foundation

protocol ActivityCreateUseCase {
    func setEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never>
}

final class DefaultActivityCreateUseCase: ActivityCreateUseCase {
    func setEnableNextButton(content: String, title: String) -> AnyPublisher<Bool, Never> {
        return Just(!content.isEmpty && !title.isEmpty).eraseToAnyPublisher()
    }
}
