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
    let startDate: String?
    let endDate: String?
    let location: String?
    let participants: [Int]?
}
