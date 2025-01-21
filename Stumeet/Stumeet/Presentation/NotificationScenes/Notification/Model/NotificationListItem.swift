//
//  NotificationListItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import Foundation

struct NotificationListItem: Hashable {
    let reminder: Reminder
    var id: Int { reminder.id }
    var title: String {
        reminder.title + (reminder.content ?? "")
    }
    var alertTime: String? { reminder.createdAt?.timeAgoSince()}
    var thumbnailImageUrl: String? { reminder.image }
}
