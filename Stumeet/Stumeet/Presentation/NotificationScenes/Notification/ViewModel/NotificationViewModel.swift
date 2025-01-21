//
//  NotificationViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import Combine
import Foundation

final class NotificationViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadData: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let notificationDataSource: AnyPublisher<[NotificationListItem], Never>
    }
    
    // MARK: - Properties
    private var fetchNotificationsUseCase: FetchNotificationsUseCase
    
    private var currentPage: Int = 0
    
    private var notificationItemsSubject = CurrentValueSubject<[NotificationListItem], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchNotificationsUseCase: FetchNotificationsUseCase
    ) {
        self.fetchNotificationsUseCase = fetchNotificationsUseCase
    }
    
    func transform(input: Input) -> Output {
        let notificationDataSource = notificationItemsSubject.eraseToAnyPublisher()
       
        // TODO: API 연동 시 수정
        input.loadData
            .map { self.currentPage }
            .flatMap(fetchNotificationsUseCase.execute(page:))
            .compactMap(updateNotificationPageData(receiveValue:))
            .sink(receiveValue: notificationItemsSubject.send)
            .store(in: &cancellables)
        
        return Output(
            notificationDataSource: notificationDataSource
        )
    }
    
    // MARK: - Function
    private func convertToNotificationViewItems(
        from reminderPage: ReminderPage
    ) -> [NotificationListItem] {
        return reminderPage.reminders.map {
            NotificationListItem(reminder: $0)
        }
    }
    
    private func updateNotificationPageData(receiveValue: ReminderPage) -> [NotificationListItem]? {
        let newItems = convertToNotificationViewItems(from: receiveValue)
        
        var updateDataSource = notificationItemsSubject.value
        
        updateDataSource.append(contentsOf: newItems)
        
        let uniquedData = Array(updateDataSource.uniqued())
        
        return uniquedData
    }
}
