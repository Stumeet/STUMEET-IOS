//
//  Reminder.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/21.
//

import Foundation

struct Reminder: Hashable {
    let id: Int
    let title: String
    let content: String?
    let image: String?
    let createdAt: String?
    
    init(
        id: Int,
        title: String,
        content: String? = nil,
        image: String? = nil,
        createdAt: String? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.image = image
        self.createdAt = createdAt
    }
}

struct ReminderPage: Equatable {
    let pageInfo: PageInfo
    let reminders: [Reminder]
}
