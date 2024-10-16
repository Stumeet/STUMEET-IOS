//
//  StudyMemberActivityViewItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import Foundation

struct StudyMemberActivityViewItem: Hashable {
    
    private let activity: Activity

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
    
    internal init(
        activity: Activity
    ) {
        self.activity = activity
    }
}
