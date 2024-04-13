//
//  Calendar.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import Foundation

struct CalendarDay: Hashable {
    var day: String
    let weeks: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    var days: [String]
}
