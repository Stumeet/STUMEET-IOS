//
//  NotificationRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Combine
import Moya

protocol NotificationRepository {
    func requestUpdateFCMToken(fcmToken: String, deviceID: String) -> AnyPublisher<Void, Never>
    func fetchNotificationList(
        size: Int,
        page: Int
    ) -> AnyPublisher<ReminderPage, MoyaError>
}
