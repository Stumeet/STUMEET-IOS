//
//  FetchMemberReviewRequestDTO.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Foundation

struct FetchMemberReviewRequestDTO: Encodable {
    let size: Int
    let page: Int
    let sort: String
}
