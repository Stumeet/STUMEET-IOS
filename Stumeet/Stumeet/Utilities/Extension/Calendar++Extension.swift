//
//  Calendar++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/24.
//

import Foundation

extension Calendar {
    static var korean: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }
}
