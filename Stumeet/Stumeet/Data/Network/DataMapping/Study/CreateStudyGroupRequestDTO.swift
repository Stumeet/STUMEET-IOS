//
//  CreateStudyGroupRequestDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 9/1/24.
//

import Foundation

struct CreateStudyGroupRequestDTO: Encodable {
    let image: Data?
    let studyField: String
    let name: String
    let intro: String
    let region: String
    let rule: String
    let startDate: String
    let endDate: String
    let meetingTime: String
    let meetingRepetitionType: String
    let meetingRepetitionDates: [String]
    let studyTags: [String]
}
