//
//  StudiesDetailResponseDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Foundation

struct StudiesDetailResponseDTO: Decodable {
    let id: Int
    let name: String
    let field: String
    let tags: [String]
    let intro: String
    let region: String
    let rule: String
    let image: String
    let headcount: Int
    let startDate: String
    let endDate: String
    let meetingTime: String
    let meetingRepetitionType: String
    let meetingRepetitionDates: [String]
    let isFinished: Bool
    let isDeleted: Bool
}

extension StudiesDetailResponseDTO {
    func toDomain() -> StudyGroupDetail {
        return .init(
            id: id,
            name: name,
            field: field,
            tags: tags,
            intro: intro,
            region: region,
            rule: rule,
            image: image,
            headcount: headcount,
            startDate: startDate,
            endDate: endDate,
            meetingTime: meetingTime,
            meetingRepetitionType: meetingRepetitionType,
            meetingRepetitionDates: meetingRepetitionDates,
            isFinished: isFinished,
            isDeleted: isDeleted
        )
    }
}
