//
//  StudyMemberResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/5/24.
//

import Foundation

struct StudyMemberResponseDTO: Decodable {
    let studyMembers: [StudyMemberItemResponseDTO]
}

extension StudyMemberResponseDTO {
    struct StudyMemberItemResponseDTO: Decodable {
        let id: Int
        let name: String
        let image: String
    }
}

extension StudyMemberResponseDTO.StudyMemberItemResponseDTO {
    func toDomain() -> ActivityMember {
        ActivityMember(
            id: id,
            imageURL: image,
            name: name,
            isSelected: false
        )
    }
}
