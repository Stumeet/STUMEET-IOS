//
//  ScheduleItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/26.
//

import Foundation

struct ScheduleItem: Hashable, Identifiable {
    
    let activity: Activity
    var id: Int { activity.id }
    
    var type: ActivityCategory? {
        activity.tag
    }
    
    var isTimeExpired: Bool {
        switch activity.tag {
        case .homework:
            activity.endTime?.isTimeExpired() ?? true
        case .meeting:
            activity.startTiem?.isTimeExpired() ?? true
        default: true
        }
    }
    
    var displayStudyName: String {
        activity.studyName ?? "알 수 없음"
    }
    
    var displayTitle: String {
        activity.title
    }
    
    var displayStartTiem: String {
        activity.startTiem?.formattedDateHHmm() ?? "0000.00.00 00:00"
    }
    
    var displayEndTime: String {
        activity.endTime?.formattedDateHHmm() ?? "0000.00.00 00:00" + "까지"
    }
    
    var displayDate: String {
        switch type {
        case .homework: displayEndTime
        case .meeting: displayStartTiem
        default: ""
        }
    }
    
    var displayLocation: String {
        activity.place ?? "장소"
    }
    
    var displayState: ActivityState? {
        activity.status
    }
    
    var displayRemainingTime: String {
        switch activity.tag {
        case .homework:
            activity.endTime?.timeUntilSince() ?? "알 수 없음"
        case .meeting:
            activity.startTiem?.timeUntilSince() ?? "알 수 없음"
        default: "알 수 없음"
        }
    }
    
    init(activity: Activity) {
        self.activity = activity
    }
}
