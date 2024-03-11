//
//  StartUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/11/24.
//

import Combine
import Foundation

protocol StartUseCase {
    func signUp(register: Register) -> AnyPublisher<Bool, Never>
}

final class DefaultStartUseCase: StartUseCase {
    
    private let repository: StartRepository
    
    init(repository: StartRepository) {
        self.repository = repository
    }
    
    func signUp(register: Register) -> AnyPublisher<Bool, Never> {
        return repository.signUp(register: register)
            .filter { $0 }
            .eraseToAnyPublisher()
    }
}
