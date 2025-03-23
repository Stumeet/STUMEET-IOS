//
//  FetchMemberReviewTagStatsResponseDTO.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Foundation

struct FetchMemberReviewTagStatsResponseDTO: Decodable {
    let totalCount: Int?
    let tagCountStats: [TagCountStatsResponseDTO]?
}

extension FetchMemberReviewTagStatsResponseDTO {
    struct TagCountStatsResponseDTO: Decodable {
        let reviewTagName: String?
        let count: Int?
    }
}

// MARK: - Mappings to Domain
extension FetchMemberReviewTagStatsResponseDTO {
    func toDomain() -> (Int, [ReviewTag]) {
        let totalTagCount: Int = totalCount ?? 0
        let reviewTags: [ReviewTag] = tagCountStats?.compactMap { $0.toDomain() } ?? []
        return (totalTagCount, reviewTags)
    }
}

extension FetchMemberReviewTagStatsResponseDTO.TagCountStatsResponseDTO {
    func toDomain() -> ReviewTag {
        return .init(name: reviewTagName ?? "", count: 0)
    }
}
