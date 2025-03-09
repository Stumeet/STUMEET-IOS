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
    
    var isTimeExpired: Bool? {
        switch activity.tag {
        case .homework:
            activity.endTime?.isTimeExpired() ?? true
        case .meeting:
            activity.startTiem?.isTimeExpired() ?? true
        default: true
        }
    }
    
    var displayStudyName: String? {
        activity.studyName
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
        switch activity.tag {
        case .homework:
            activity.endTime?.timeUntilSince() ?? "알 수 없음"
        case .meeting:
            activity.startTiem?.timeUntilSince() ?? "알 수 없음"
        default: "알 수 없음"
        }
    }

    internal init(activity: Activity) {
        self.activity = activity
    }
}
