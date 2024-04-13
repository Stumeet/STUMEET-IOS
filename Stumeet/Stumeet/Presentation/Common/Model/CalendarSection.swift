//
//  CalendarSection.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import Foundation

enum CalendarSection: Int {
    case week
    case day
}

enum CalendarSectionItem: Hashable {
    case weekCell(String)
    case dayCell(String)
}
