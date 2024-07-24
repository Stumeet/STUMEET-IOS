//
//  BriefStudyActivityResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/2/24.
//

import Foundation

struct BriefStudyActivityRequestDTO: Encodable {
    let size: Int
    let page: Int
    let isNotice: Bool?
    let studyId: Int?
    let category: String?
    let fromDate: String?
    let toDate: String?
}
