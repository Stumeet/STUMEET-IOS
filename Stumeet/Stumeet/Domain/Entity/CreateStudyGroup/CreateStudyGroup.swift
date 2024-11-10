//
//  CreateStudyGroup.swift
//  Stumeet
//
//  Created by 정지훈 on 8/25/24.
//

import Foundation

struct CreateStudyGroup {
    let image: Data?
    let name: String
    let field: String
    let tags: [String]
    let explain: String
    let region: String
    let startDate: String
    let endDate: String
    let time: String?
    let repetType: StudyRepeatType?
    let repetDays: [String]?
    let rule: String
}
