//
//  StudyMainViewActivityItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/21.
//

import Foundation

struct StudyMainViewActivityItem {

    let id: Int
    let type: ActivityCategory
    let title: String
    let content: String
    let startTiem: String?
    let endTime: String?
    let place: String?
    let authorProfileImage: String?
    let authorName: String
    let createdAt: String
    let cellType: StudyMainActivityCellStyle
    
    var displayCreatedAt: String? {
        createdAt.timeAgoSince()
    }
    
    var displayStartTiem: String? {
        startTiem?.formattedDateHHmm()
    }
    
    var displayEndTime: String? {
        endTime?.formattedDateHHmm()
    }
    
    enum StudyMainActivityCellStyle {
        case notice
        case activityFirstCell
        case normal
    }
    
    internal init(
        id: Int,
        type: ActivityCategory,
        title: String,
        content: String,
        startTiem: String? = nil,
        endTime: String? = nil,
        place: String? = nil,
        authorProfileImage: String? = nil,
        authorName: String,
        createdAt: String,
        cellType: StudyMainActivityCellStyle
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.content = content
        self.startTiem = startTiem
        self.endTime = endTime
        self.place = place
        self.authorProfileImage = authorProfileImage
        self.authorName = authorName
        self.createdAt = createdAt
        self.cellType = cellType
    }
}
