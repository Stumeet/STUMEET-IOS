//
//  DetailActivityResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/14/24.
//

import Foundation

struct DetailActivityResponseDTO: Decodable {
    let id: Int
    let category: String
    let title, content: String
    let imageUrl: [ImageResponseDTO]
    let author: AuthorResponseDTO
    let participants: [ParticipantsMemeberResponseDTO]
    let status: String
    let startDate, endDate: String?
    let location: String?
    let createdAt: String
    
}

extension DetailActivityResponseDTO {
    struct ImageResponseDTO: Decodable {
        let imageUrl: String
    }
    
    struct AuthorResponseDTO: Decodable {
        let memberId: Int
        let name: String
        let profileImageUrl: String
    }
    
    struct ParticipantsMemeberResponseDTO: Decodable {
        let profileImageUrl: String?
    }
    
    func toDomain() -> DetailStudyActivity {
        var detailActivity = DetailStudyActivity()
        
        detailActivity.top = DetailStudyActivity.Top(
            id: id,
            category: ActivityCategory(rawValue: category)!,
            dayLeft: endDate,
            status: ActivityState(rawValue: status)!,
            profileImageURL: author.profileImageUrl,
            name: author.name,
            date: createdAt,
            title: title,
            content: content
        )
        
        detailActivity.photo = DetailStudyActivity.Photo(
            imageURL: imageUrl.map { $0.imageUrl }
        )
        
        detailActivity.bottom = DetailStudyActivity.Bottom(
            memberImageURL: participants.map { $0.profileImageUrl },
            startDate: startDate,
            endDate: endDate,
            place: location)
        
        return detailActivity
    }
}
