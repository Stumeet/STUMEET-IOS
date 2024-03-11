//
//  DefualtStartRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 3/11/24.
//

import Combine
import Foundation

import Moya

final class DefualtStartRepository: StartRepository {
    
    private let provider: MoyaProvider<RegisterService>
    
    init(provider: MoyaProvider<RegisterService>) {
        self.provider = provider
    }
    
    func signUp(register: Register) -> AnyPublisher<Bool, Never> {
        let requestDTO = RegisterRequestDTO(
            nickname: register.nickname!,
            region: register.region!,
            profession: register.field!)
        
        return provider.requestPublisher(.signUp(register.profileImage, requestDTO))
            .map(RegisterResponseDTO.self)
            .map { _ in return true }
            .catch { _ in Just(false) }
            .eraseToAnyPublisher()
    }
}
