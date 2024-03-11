//
//  StartRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 3/11/24.
//

import Combine
import Foundation

protocol StartRepository {
    func signUp(register: Register) -> AnyPublisher<Bool, Never>
}
