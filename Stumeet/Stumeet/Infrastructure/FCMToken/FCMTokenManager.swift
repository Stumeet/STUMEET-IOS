//
//  FCMTokenManager.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Combine

class FCMTokenManager {
    private let repository: NotificationRepository
    private var cancellables: Set<AnyCancellable> = []

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func updateFCMToken(fcmToken: String, deviceID: String) {
        repository.requestUpdateFCMToken(fcmToken: fcmToken, deviceID: deviceID)
            .sink( receiveValue: { } )
            .store(in: &cancellables)
    }
}
