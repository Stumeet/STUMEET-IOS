//
//  DetailAcitivtyMember.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import UIKit

struct DetailActivityMember: Hashable {
    let name: String?
    let state: ActivityState
    let profileImageURL: String?
}

enum ActivityState: String {
    case perform = "수행"
    case notperform = "미수행"
    case attendance = "출석"
    case absent = "결석"
    case late = "지각"
    case okAbsent = "인정결석"
    case okPerform = "지각제출"
    case noParticipation = "미참여"
    case beforeStart = "시작 전"
    
    var primaryColor: UIColor {
        switch self {
        case .perform: StumeetColor.primary700.color
        case .notperform: StumeetColor.danger500.color
        case .attendance: StumeetColor.primary700.color
        case .absent: StumeetColor.danger500.color
        case .late: StumeetColor.warning500.color
        case .okAbsent: StumeetColor.danger500.color
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
        case .beforeStart: StumeetColor.gray75.color
        default: StumeetColor.gray75.color
        }
    }
}
