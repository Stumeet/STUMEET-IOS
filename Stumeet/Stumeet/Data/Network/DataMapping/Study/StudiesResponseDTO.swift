//
//  StudiesResponseDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/07.
//

import Foundation

struct StudiesResponseDTO: Decodable {
    let studySimpleResponses: [StudyGroupDTO]
}

extension StudiesResponseDTO {
    struct StudyGroupDTO: Decodable {
        let id: Int
        let name: String
        let field: String
        let tags: [String]
        let image: String
        let headcount: Int
        let startDate: String
        let endDate: String
    }
}

extension StudiesResponseDTO.StudyGroupDTO {
    func toDomain() -> StudyGroup {
        return .init(id: id, name: name, field: field, tags: tags, image: image, headcount: headcount, startDate: startDate, endDate: endDate)
    }
}
