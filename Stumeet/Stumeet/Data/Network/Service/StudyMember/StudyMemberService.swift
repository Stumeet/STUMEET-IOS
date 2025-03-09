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
    case fetchStudyMemberDetailInfo(StudyMemberDetailRequestDTO)
    case removeStudyMember(StudyMemberRemoveRequestDTO)
    case delegateAdminRights(StudyAdminDelegateRequestDTO)
    case updateMemberActivityStatus(StudyMemberActivityStatusRequestDTO)
}

extension StudyMemberService: BaseTargetType {
    var path: String {
        switch self {
        case .fetchStudyMembers(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/members"
        case .adminCheck(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/me/admin/check"
        case .fetchStudyMemberDetailInfo(let requestDTO):
            return "api/external/v1/studies/\(requestDTO.studyId)/members/\(requestDTO.memberId)"
        case .removeStudyMember(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/members/\(requestDTO.memberId)"
        case .delegateAdminRights(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/members/\(requestDTO.memberId)/admin/delegate"
        case .updateMemberActivityStatus(let requestDTO):
            return "api/v1/studies/\(requestDTO.studyId)/activities/\(requestDTO.activityId)/status"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchStudyMembers, .adminCheck, .fetchStudyMemberDetailInfo:
            return .get
        case .removeStudyMember:
            return .delete
        case .delegateAdminRights, .updateMemberActivityStatus:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchStudyMembers, .adminCheck, .fetchStudyMemberDetailInfo, .removeStudyMember, .delegateAdminRights:
            return .requestPlain
        case .updateMemberActivityStatus(let requestDTO):
            return .requestParameters(parameters: requestDTO.toJSON, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .updateMemberActivityStatus:
            return ["Content-Type": "application/json"]
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}
