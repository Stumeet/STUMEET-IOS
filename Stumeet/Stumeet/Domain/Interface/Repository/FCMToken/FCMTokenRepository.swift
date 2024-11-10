//
//  FCMTokenRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Combine
import Moya

protocol FCMTokenRepository {
    func requestUpdateFCMToken(fcmToken: String, deviceID: String) -> AnyPublisher<Void, Never>
}
