//
//  BreifStudyActivityResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/2/24.
//

import Foundation

struct BreifStudyActivityResponseDTO: Decodable {
    let items: [BreifActivityItemResponseDTO]
}

extension BreifStudyActivityResponseDTO {
    struct BreifActivityItemResponseDTO: Decodable {
        let id: Int
        let category, title, startDate, endDate: String
        let location: String?
        let status, createdAt: String
    }
}

extension BreifStudyActivityResponseDTO.BreifActivityItemResponseDTO {
    func toDomain() -> Activity {
        return Activity(
            id: id,
            tag: category,
            title: title,
            content: nil,
            startTiem: startDate,
            endTime: endDate,
            place: location,
            image: nil,
            name: nil,
            day: createdAt,
            status: status)
    }
}
