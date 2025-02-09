//
//  HomeNoticeItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/02/03.
//

import Foundation

struct HomeNoticeItem: ActivityRepresentable, Hashable, Identifiable {
    
    let activity: Activity
    var id: Int { activity.id }
    
    var displayStudyName: String? {
        activity.studyName ?? "알 수 없음"
    }
    
    var displayActivityTitle: String? {
        activity.title
    }
    
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
    
    var displayRemainingTime: String?

    init(activity: Activity) {
        self.activity = activity
    }
}
