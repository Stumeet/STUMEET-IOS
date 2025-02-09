//
//  BreifStudyActivityResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 7/2/24.
//

import Foundation

struct BreifStudyActivityResponseDTO: Decodable {
    let items: [BreifActivityItemResponseDTO]
    let pageInfo: PageInfoResponseDTO?
}

extension BreifStudyActivityResponseDTO {
    struct BreifActivityItemResponseDTO: Decodable {
        let id: Int
        let category, title, startDate, endDate: String
        let location, studyName: String?
        let status, createdAt: String
    }
    
    func toDomain() -> ActivityPage {
        if let pageInfo {
            return .init(pageInfo: pageInfo.toDomain(),
                         activitys: items.map { $0.toDomain() })
        } else {
            return .init(pageInfo: PageInfo(totalPages: 0, totalElements: 0, currentPage: 0, pageSize: 0),
                         activitys: items.map { $0.toDomain() })
        }
        
    }
}

extension BreifStudyActivityResponseDTO.BreifActivityItemResponseDTO {
    func toDomain() -> Activity {
        return Activity(
            id: id,
            tag: ActivityCategory(rawValue: category),
            title: title,
            content: nil,
            startTiem: startDate,
            endTime: endDate,
            place: location,
            image: nil,
            name: nil,
            studyName: studyName,
            day: createdAt,
            status: ActivityState(rawValue: status)!)
    }
}
