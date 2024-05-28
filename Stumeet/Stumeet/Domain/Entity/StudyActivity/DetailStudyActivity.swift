//
//  DetailStudyActivity.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import Foundation

struct DetailStudyActivityTop: Hashable {
    let dayLeft: String
    let status: String
    let profileImageURL: String
    let name: String
    let date: String
    let title: String
    let content: String
}

struct DetailStudyActivityPhoto: Hashable {
    let imageURL: String
}

struct DetailStudyActivityBottom: Hashable {
    let memberImageURL: [String]
    let startDate: String
    let endDate: String
    let place: String
}
