//
//  CreateActivity.swift
//  Stumeet
//
//  Created by 정지훈 on 7/4/24.
//

import Foundation

struct CreateActivity: Equatable {
    let category: ActivityCategory
    let title: String
    let content: String
    let images: [Data]?
    let isNotice: Bool
    var startDate: String?
    var endDate: String?
    var location: String?
    var participants: [Int]?
}
