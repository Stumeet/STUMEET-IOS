//
//  FetchNotificationsUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/21.
//

import Combine

protocol FetchNotificationsUseCase {
    func execute(page: Int) -> AnyPublisher<ReminderPage, Never>
}

final class DefaultFetchNotificationsUseCase: FetchNotificationsUseCase {
    private let repository: NotificationRepository

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func execute(page: Int) -> AnyPublisher<ReminderPage, Never> {
        return repository.fetchNotificationList(
            size: 15,
            page: page
        )
        .catch { error -> AnyPublisher<ReminderPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }
}
