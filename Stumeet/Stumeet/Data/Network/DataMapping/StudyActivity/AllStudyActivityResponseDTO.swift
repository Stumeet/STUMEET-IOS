//
//  AllStudyActivityResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/2/24.
//

import Foundation

struct AllStudyActivityResponseDTO: Decodable {
    let items: [ActivityItemResponseDTO]
}

extension AllStudyActivityResponseDTO {
    struct ActivityItemResponseDTO: Decodable {
        let id: Int
        let category, title, content: String
        let startDate, endDate: String?
        let location: String?
        let author: AuthorResponseDTO
        let createdAt: String
    }
}

extension AllStudyActivityResponseDTO.ActivityItemResponseDTO {
    struct AuthorResponseDTO: Decodable {
        let memberID: Int
        let name: String
        let profileImageURL: String
        
        enum CodingKeys: String, CodingKey {
            case memberID = "memberId"
            case name
            case profileImageURL = "profileImageUrl"
        }
    }
    
    func toDomain() -> Activity {
        return Activity(
            id: id,
            tag: ActivityCategory(rawValue: category),
            title: title,
            content: content,
            startTiem: startDate,
            endTime: endDate,
            place: location,
            image: author.profileImageURL,
            name: author.name,
            day: createdAt,
            status: nil
        )
    }
}