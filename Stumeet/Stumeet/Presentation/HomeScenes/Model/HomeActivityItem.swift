//
//  HomeActivityItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/04.
//

import Foundation

struct HomeActivityItem: ActivityRepresentable, Hashable, Identifiable {
    
    let activity: Activity
    var id: Int { activity.id }
    
    var displayStudyName: String? {
        "스터디명"
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
    
    var displayRemainingTime: String? {
        "9시간 30분 남음"
    }

    internal init(activity: Activity) {
        self.activity = activity
    }
}
