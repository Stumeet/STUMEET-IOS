//
//  ReminderResponseDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/21.
//


import Foundation

struct RemindersResponseDTO: Decodable {
    let notificationLogs: [ReminderResponseDTO]
    let pageInfo: PageInfoResponseDTO
}

extension RemindersResponseDTO {
    struct ReminderResponseDTO: Decodable {
        let id: Int
        let title: String?
        let body: String?
        let imgUrl: String?
        let createdAt: String?
    }
}
extension RemindersResponseDTO {
    func toDomain() -> ReminderPage {
        return .init(pageInfo: pageInfo.toDomain(),
                     reminders: notificationLogs.map { $0.toDomain() })
    }
}

extension RemindersResponseDTO.ReminderResponseDTO {
    func toDomain() -> Reminder {
        return .init(
            id: id,
            title: title ?? "",
            content: body,
            image: imgUrl,
            createdAt: createdAt
        )
    }
}
