//
//  Activity.swift
//  Stumeet
//
//  Created by 정지훈 on 2/27/24.
//

import Foundation

struct Activity: Hashable {
    let id: Int
    let tag: ActivityCategory?
    let title: String
    let content: String?
    let startTiem: String?
    let endTime: String?
    let place: String?
    let image: String?
    let name: String?
    let studyName: String?
    let day: String?
    let status: ActivityState?
    
    init(
        id: Int,
        tag: ActivityCategory? = nil,
        title: String,
        content: String? = nil,
        startTiem: String? = nil,
        endTime: String? = nil,
        place: String? = nil,
        image: String? = nil,
        name: String? = nil,
        studyName: String? = nil,
        day: String? = nil,
        status: ActivityState? = nil
    ) {
        self.id = id
        self.tag = tag
        self.title = title
        self.content = content
        self.startTiem = startTiem
        self.endTime = endTime
        self.place = place
        self.image = image
        self.name = name
        self.studyName = studyName
        self.day = day
        self.status = status
    }
}

struct ActivityPage: Equatable {
    let pageInfo: PageInfo
    let activitys: [Activity]
}
