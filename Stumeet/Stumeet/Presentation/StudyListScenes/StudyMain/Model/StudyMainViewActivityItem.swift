//
//  StudyMainViewActivityItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/21.
//

import Foundation

struct StudyMainViewActivityItem: Hashable, Identifiable {
    
    let activity: Activity
    var id: Int { activity.id }
    var cellType: StudyMainActivityCellStyle

    var displayAuthorName: String {
        activity.name ?? "악명"
    }
    
    var displayType: ActivityCategory {
        activity.tag ?? .freedom
    }
    
    var displayCreatedAt: String? {
        activity.day?.timeAgoSince()
    }
    
    var displayStartTiem: String? {
        activity.startTiem?.formattedDateHHmm()
    }
    
    var displayEndTime: String? {
        activity.endTime?.formattedDateHHmm()
    }
    
    enum StudyMainActivityCellStyle {
        case notice
        case activityFirstCell
        case normal
    }
    
    internal init(activity: Activity, cellType: StudyMainViewActivityItem.StudyMainActivityCellStyle) {
        self.activity = activity
        self.cellType = cellType
    }
}
