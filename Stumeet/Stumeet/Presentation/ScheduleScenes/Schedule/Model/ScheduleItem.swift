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
    
    var displayTitle: String {
        activity.title
    }
    
    var displayStartTiem: String {
        activity.startTiem?.formattedDateHHmm() ?? "0000.00.00 00:00"
    }
    
    var displayEndTime: String {
        activity.endTime?.formattedDateHHmm() ?? "0000.00.00 00:00" + "까지"
    }
    
    var displayLocation: String {
        activity.place ?? "장소"
    }
    
    var displayState: ActivityState? {
        activity.status
    }
    
    init(activity: Activity) {
        self.activity = activity
    }
}
