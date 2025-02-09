//
//  HomeHeaderActivityItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/02/02.
//

import Foundation

struct HomeHeaderActivityItem {
    
    let activity: Activity
    
    var displayStudyName: String {
        activity.studyName ?? "알 수 없음"
    }
    
    var displayActivityTitle: String {
        activity.title
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
