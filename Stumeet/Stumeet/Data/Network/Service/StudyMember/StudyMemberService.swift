//
//  StudyMemberService.swift
//  Stumeet
//
//  Created by 정지훈 on 7/5/24.
//

import Foundation

import Moya

enum StudyMemberService {
    case fetchStudyMembers(StudyMemberRequestDTO)
}

extension StudyMemberService: BaseTargetType {
    var path: String {
        switch self {
        case .fetchStudyMembers(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchStudyMembers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchStudyMembers:
            return .requestPlain
        }
    }
}
