//
//  Calendar.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import Foundation

struct CalendarData {
    let selectedDate: Date?
    let data: [CalendarDate]
}

struct CalendarDate: Hashable {
    let date: String
    var isSelected: Bool = false
    var isPast: Bool = false
}

struct CalendarWeek {
    static let weeks = ["월", "화", "수", "목", "금", "토", "일"]
}
