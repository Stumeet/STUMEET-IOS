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
        let region: String
        let profession: String
        let isAdmin: Bool
    }
}

extension StudyMemberResponseDTO.StudyMemberItemResponseDTO {
    // !IMP: - 기존에 작성하신게 있어서 아래처럼 분기를 했는데 StudyMember에 ActivityMember을 병합하는건 어떻게 생각하세요
    func toDomain() -> ActivityMember {
        ActivityMember(
            id: id,
            imageURL: image,
            name: name,
            isSelected: false
        )
    }
    
    func toDomainForStudyMember() -> StudyMember {
        StudyMember(
            id: id,
            name: name,
            image: image,
            region: region,
            profession: profession,
            isAdmin: isAdmin
        )
    }
}
