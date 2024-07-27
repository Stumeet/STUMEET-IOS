//
//  StudyGroupDetail.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Foundation

struct StudyGroupDetail: Hashable {
    let id: Int
    let name: String
    let field: String
    let tags: [String]
    let intro: String
    let region: String
    let rule: String
    let image: String
    let headcount: Int
    let startDate: String
    let endDate: String
    let meetingTime: String
    let meetingRepetitionType: String
    let meetingRepetitionDates: [String]
    let isFinished: Bool
    let isDeleted: Bool
}
