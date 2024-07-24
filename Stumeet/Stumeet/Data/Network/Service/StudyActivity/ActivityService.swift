//
//  ActivityService.swift
//  Stumeet
//
//  Created by 정지훈 on 7/2/24.
//

import Moya

enum ActivityService {
    case fetchAllActivities(AllStudyActivityRequestDTO)
    case fetchBriefActivities(BriefStudyActivityRequestDTO)
    case postActivity(PostActivityRequestDTO)
    case fetchDetailActivity(DetailActivityRequestDTO)
    case fetchDetailActivityMember(DetailActivityRequestDTO)
}

extension ActivityService: BaseTargetType {
    var path: String {
        switch self {
        case .fetchAllActivities:
            return "/api/v1/studies/activities/detail"
        case .fetchBriefActivities:
            return "/api/v1/studies/activities/brief"
        case .postActivity:
            return "/api/v1/studies/1/activities"
        case .fetchDetailActivity(let requestDTO):
            return "/api/v1/studies/\(requestDTO.studyId)/activities/\(requestDTO.activityId)"
        case .fetchDetailActivityMember(let requestDTO):
            return "/api/v1/studies/\(requestDTO.studyId)/activities/\(requestDTO.activityId)/members"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchAllActivities, .fetchBriefActivities, .fetchDetailActivity, .fetchDetailActivityMember:
            return .get
        case .postActivity:
            return .post
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
            
        case .postActivity(let requestDTO):
            return .requestJSONEncodable(requestDTO)
            
        case .fetchDetailActivity(let requestDTO):
            guard let dto = requestDTO.toDictionary else { return .requestPlain }
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
            
        case .fetchDetailActivityMember(let requestDTO):
            guard let dto = requestDTO.toDictionary else { return .requestPlain }
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
