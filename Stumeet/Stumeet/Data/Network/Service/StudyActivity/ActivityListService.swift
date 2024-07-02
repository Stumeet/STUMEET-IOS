//
//  ActivityListService.swift
//  Stumeet
//
//  Created by 정지훈 on 7/2/24.
//

import Moya

enum ActivityListService {
    case fetchAllActivities(AllStudyActivityRequestDTO)
    case fetchBriefActivities(BriefStudyActivityRequestDTO)
}

extension ActivityListService: BaseTargetType {
    var path: String {
        switch self {
        case .fetchAllActivities:
            return "/api/v1/studies/activities/detail"
        case .fetchBriefActivities:
            return "/api/v1/studies/activities/brief"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchAllActivities, .fetchBriefActivities:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchAllActivities(let requestDTO):
            guard let dto = requestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
            
        case .fetchBriefActivities(let requestDTO):
            guard let dto = requestDTO.toDictionary else { return .requestPlain }
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
        }
    }
}
