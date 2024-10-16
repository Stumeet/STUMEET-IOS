//
//  StudyMemberMeetingStateListItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/05.
//

import UIKit

struct StudyMemberMeetingStateListItem: Hashable, Identifiable {
    
    let id: Int
    var isStateHidden: Bool
    var attendanceState: AttendanceState
    
    enum AttendanceState: Int, CaseIterable {
        case present = 0
        case late
        case excusedAbsence
        case absence
        
        var title: String {
            switch self {
            case .present: "출석"
            case .late: "지각"
            case .excusedAbsence: "인정결석"
            case .absence: "결석"
            }
        }
    
        var primaryColor: UIColor {
            switch self {
            case .present:
                return StumeetColor.primary700.color
            case .late:
                return StumeetColor.warning500.color
            case .excusedAbsence:
                return StumeetColor.danger500.color
            case .absence:
                return StumeetColor.danger500.color
            }
        }
        
        var secondaryColor: UIColor {
            switch self {
            case .present:
                return StumeetColor.primary50.color
            case .late:
                return StumeetColor.warning50.color
            case .excusedAbsence:
                return StumeetColor.danger50.color
            case .absence:
                return StumeetColor.danger50.color
            }
        }
    }
}
