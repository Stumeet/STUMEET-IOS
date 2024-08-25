//
//  StudyRepeatType.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import Foundation

enum StudyRepeatType {
    case dailiy
    case weekly([String])
    case monthly([String])
}

extension StudyRepeatType {
    var title: String {
        switch self {
        case .dailiy:
            return "매일"
        case .weekly:
            return "매주"
        case .monthly:
            return "매월"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .dailiy:
            return 245
        case .weekly:
            return 301
        case .monthly:
            return 518
        }
    }
    
    var days: [String] {
        switch self {
        case .dailiy:
            return []
        case .weekly(let days), .monthly(let days):
            return days
        }
    }
}
