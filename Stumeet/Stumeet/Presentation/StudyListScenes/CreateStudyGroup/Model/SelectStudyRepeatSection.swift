//
//  SelectStudyRepeatSection.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import Foundation

enum SelectStudyRepeatSection {
    case main
}

enum SelectStudyRepeatSectionItem: Hashable {
    case monthlyCell(CalendarDate)
}
