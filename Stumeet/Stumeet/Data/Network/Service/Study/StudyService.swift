//
//  StudyService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/07.
//

import Moya

enum StudyService {
    case detailStudyGroupsInfo(_ studyId: Int) // 스터디 상세 정보 조회
    case listJoinedStudyGroups(StudiesRequestDTO) // 가입 스터디 리스트 조회
}

extension StudyService: BaseTargetType {

    var path: String {
        switch self {
        case .detailStudyGroupsInfo(let studyId):
            return "/api/v1/studies/\(studyId)"
        case .listJoinedStudyGroups:
            return "/api/v1/studies"
        }
    }
    
    var method: Method {
        switch self {
        case .detailStudyGroupsInfo, .listJoinedStudyGroups :
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .detailStudyGroupsInfo :
            return .requestPlain
        case .listJoinedStudyGroups(let studiesRequestDTO):
            guard let dto = studiesRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
        }
    }

}
