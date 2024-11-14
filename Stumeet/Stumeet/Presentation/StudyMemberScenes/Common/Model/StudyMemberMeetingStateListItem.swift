//
//  StudyMemberMeetingStateListItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/05.
//

import UIKit

struct StudyMemberMeetingStateListItem: Hashable, Identifiable {
    
    private var detailActivityMember: DetailActivityMember
    var id: Int? { detailActivityMember.id }
    var isStateHidden: Bool = true
    
    var name: String {
        detailActivityMember.name ?? "-"
    }
    
    var profileImage: String? {
        detailActivityMember.profileImageURL
    }
    
    var attendanceState: AttendanceState {
        get {
            switch detailActivityMember.state {
            case .attendance: .present
            case .late: .late
            case .okAbsent: .excusedAbsence
            case .absent: .absence
            default: .none
            }
        }
        
        set {
            detailActivityMember.state =  switch newValue {
            case .present: .attendance
            case .late: .late
            case .excusedAbsence: .okAbsent
            case .absence: .absent
            default: .none
            }
        }
    }
    
    enum AttendanceState: Int, CaseIterable {
        case present = 0
        case late
        case excusedAbsence
        case absence
        case none
        
        var title: String {
            switch self {
            case .present: "출석"
            case .late: "지각"
            case .excusedAbsence: "인정결석"
            case .absence: "결석"
            case .none: "없음"
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
            case .none:
                return StumeetColor.gray300.color
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
            case .none:
                return StumeetColor.gray75.color
            }
        }
    }
    
    init(detailActivityMember: DetailActivityMember) {
        self.detailActivityMember = detailActivityMember
    }
}
