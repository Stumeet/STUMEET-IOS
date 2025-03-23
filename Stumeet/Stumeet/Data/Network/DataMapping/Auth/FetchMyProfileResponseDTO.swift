//
//  FetchMyProfileResponseDTO.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Foundation

struct FetchMyProfileResponseDTO: Decodable {
    let id: Int?
    let image: String?
    let nickname: String?
    let region: String?
    let profession: String?
    let tier: String?
    let experience: Double?
    let grapeCount: Int?
}

extension FetchMyProfileResponseDTO {
    func toDomain() -> UserProfile {
        return .init(
            id: id ?? -1,
            profileImage: image,
            nickname: nickname,
            region: region,
            profession: profession,
            tier: .init(rawValue: tier ?? "씨앗") ?? .sprout,
            experience: experience ?? 0,
            grapeCount: grapeCount ?? 0
        )
    }
}
