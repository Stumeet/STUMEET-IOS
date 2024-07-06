//
//  PostActivityRequestDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/5/24.
//

import Foundation

struct PostActivityRequestDTO: Encodable {
    let category: String
    let title: String
    let content: String
    let images: [String]
    let isNotice: Bool
    let startDate: String
    let endDate: String
    let location: String?
    let participants: [Int]
}
