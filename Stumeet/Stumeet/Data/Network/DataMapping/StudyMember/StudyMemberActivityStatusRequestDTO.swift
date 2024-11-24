//
//  StudyMemberActivityStatusRequestDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/18.
//

import Foundation

struct StudyMemberActivityStatusRequestDTO: Encodable {
    let studyId: Int
    let activityId: Int
    let participantId: Int
    let status: String
}

extension StudyMemberActivityStatusRequestDTO {
    var toJSON: [String: Any] {
        return [
            "participantId": participantId,
            "status": status
        ]
    }
}
