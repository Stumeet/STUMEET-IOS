//
//  DefaultFCMTokenRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Moya
import CombineMoya
import Combine

class DefaultFCMTokenRepository: FCMTokenRepository {
    private let provider: MoyaProvider<FCMTokenService>
    
    init(provider: MoyaProvider<FCMTokenService>) {
        self.provider = provider
    }
    
    // TODO: - error 처리
    func requestUpdateFCMToken(fcmToken: String, deviceID: String) -> AnyPublisher<Void, Never> {
        let requestDTO = FCMTokenRequestDTO(deviceId: deviceID, notificationToken: fcmToken)
        return provider.requestPublisher(.updateFCMToken(requestDTO))
            .map { _ in }
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
}
