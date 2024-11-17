//
//  DetailAcitivtyMember.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import UIKit

struct DetailActivityMember: Hashable {
    let id: Int?
    let name: String?
    var state: ActivityState
    let profileImageURL: String?
}

enum ActivityState: String, Equatable, CaseIterable {
    case perform = "수행"
    case notperform = "미수행"
    case attendance = "출석"
    case absent = "결석"
    case late = "지각"
    case okAbsent = "인정결석"
    case okPerform = "지각제출"
    case noParticipation = "미참여"
    case beforeStart = "시작 전"
    case none = "없음"
    
    var category: ActivityCategory {
        switch self {
        case .attendance, .late, .okAbsent, .absent:
            return .meeting
        case .perform, .okPerform, .notperform:
            return .homework
        default: return .freedom
        }
    }
    
    var primaryColor: UIColor {
        switch self {
        case .perform: StumeetColor.primary700.color
        case .notperform: StumeetColor.danger500.color
        case .attendance: StumeetColor.primary700.color
        case .absent: StumeetColor.danger500.color
        case .late: StumeetColor.warning500.color
        case .okAbsent: StumeetColor.danger500.color
        case .okPerform: StumeetColor.warning500.color
        case .beforeStart: StumeetColor.gray300.color
        default: StumeetColor.gray300.color
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .perform: StumeetColor.primary50.color
        case .notperform: StumeetColor.danger50.color
        case .attendance: StumeetColor.primary50.color
        case .absent: StumeetColor.danger50.color
        case .late: StumeetColor.warning50.color
        case .okAbsent: StumeetColor.danger50.color
        case .okPerform: StumeetColor.warning50.color
        case .beforeStart: StumeetColor.gray75.color
        default: StumeetColor.gray75.color
        }
    }
}
