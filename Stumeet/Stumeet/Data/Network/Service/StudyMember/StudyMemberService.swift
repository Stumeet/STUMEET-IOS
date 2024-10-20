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
    case adminCheck(StudyMemberRequestDTO)
}

extension StudyMemberService: BaseTargetType {
    var path: String {
        switch self {
        case .fetchStudyMembers(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/members"
        case .adminCheck(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/me/admin/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchStudyMembers, .adminCheck:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchStudyMembers, .adminCheck:
            return .requestPlain
        }
    }
}
