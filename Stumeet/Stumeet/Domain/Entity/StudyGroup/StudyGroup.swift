//
//  StudyGroup.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/07.
//

import Foundation

struct StudyGroup: Hashable {
    let id: Int
    let name: String
    let field: String
    let tags: [String]
    let image: String
    let headcount: Int
    let startDate: String
    let endDate: String
}
