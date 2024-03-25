//
//  ActivityCategory.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Foundation

enum ActivityCategory {
    case freedom
    case meeting
    case homework
}

extension ActivityCategory {
    
    var title: String {
        switch self {
        case .freedom:
            return "자유"
        case .meeting:
            return "모임"
        case .homework:
            return "과제"
        }
    }
}
