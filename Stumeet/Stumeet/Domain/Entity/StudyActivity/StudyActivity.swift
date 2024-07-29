//
//  StudyActivity.swift
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
    let day: String?
    let status: ActivityState?
}

struct ActivityPage: Equatable {
    let pageInfo: PageInfo
    let activitys: [Activity]
}
