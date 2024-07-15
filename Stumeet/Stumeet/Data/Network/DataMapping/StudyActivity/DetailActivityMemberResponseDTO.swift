//
//  DetailActivityMemberResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/15/24.
//

import Foundation

struct DetailActivityMemberResponseDTO: Decodable {
    let participants: [MemberResponseDTO]
}

extension DetailActivityMemberResponseDTO {
    struct MemberResponseDTO: Decodable {
        let id: Int
        let name: String
        let profileImageUrl: String
        let status: String
    }
    
    func toDomain() -> [DetailActivityMember] {
        participants.map { member in
            DetailActivityMember(
                name: member.name,
                state: member.status,
                profileImageURL: member.profileImageUrl
            )
        }
    }
}
