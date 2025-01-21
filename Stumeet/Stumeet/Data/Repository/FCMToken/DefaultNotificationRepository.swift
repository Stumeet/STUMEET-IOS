//
//  DefaultFCMTokenRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/17.
//

import Moya
import CombineMoya
import Combine

class DefaultNotificationRepository: NotificationRepository {
    private let provider: MoyaProvider<NotificationService>
    
    init(provider: MoyaProvider<NotificationService>) {
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
    
    func fetchNotificationList(
        size: Int,
        page: Int
    ) -> AnyPublisher<ReminderPage, MoyaError> {
        let requestDTO = NotificationRequestDTO(
            size: size,
            page: page
        )
        
        return provider.requestPublisher(.fetchNotificationLogs(requestDTO))
            .map(ResponseWithDataDTO<RemindersResponseDTO>.self)
            .tryMap { response -> ReminderPage in
                guard let data = response.data else { throw MoyaError.requestMapping("Data is nil") }
                return data.toDomain()
            }
            .mapError { $0 as? MoyaError ?? MoyaError.underlying($0, nil) }
            .eraseToAnyPublisher()
    }
}
