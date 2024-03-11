//
//  DefaultNicknameRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 3/1/24.
//

import Combine
import Foundation

import Moya

final class DefaultNicknameRepository: NicknameRepository {
    
    private let provider: MoyaProvider<RegisterService>
    
    init(provider: MoyaProvider<RegisterService>) {
        self.provider = provider
    }
    
    func checkDuplicateNickname(nickname: String) -> AnyPublisher<ResponseDTO, MoyaError> {
        let requestDTO = NicknameRequestDTO(nickname: nickname)
        return provider.requestPublisher(.checkDuplicateNickname(requestDTO))
            .map(ResponseDTO.self)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
