//
//  StudyMemberDetailResponseDTO.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 2/7/25.
//

import Foundation

struct StudyMemberDetailResponseDTO: Decodable {
    let studyMemberDetailResponse: DetailResponseDTO
    let isAdmin: Bool
    let canSendGrape: Bool?
}

extension StudyMemberDetailResponseDTO {
    struct DetailResponseDTO: Decodable {
        let id: Int
        let name: String
        let image: String
        let region: String
        let profession: String
        let achievement: Int?
    }
    
    func toDomain() -> StudyMember {
        .init(
            id: studyMemberDetailResponse.id,
            name: studyMemberDetailResponse.name,
            image: studyMemberDetailResponse.image,
            region: studyMemberDetailResponse.region,
            profession: studyMemberDetailResponse.profession,
            isAdmin: isAdmin
        )
    }
}
