//
//  RegisterService.swift
//  Stumeet
//
//  Created by 정지훈 on 3/1/24.
//

import Foundation

import Moya

enum RegisterService {
    case checkDuplicateNickname(NicknameRequestDTO)
    case fetchProfessionFields
}

extension RegisterService: TargetType {
    
    // TODO: - baseurl 숨기기
    
    var baseURL: URL { return URL(string: "https://stumeet.shop")! }
    
    var path: String {
        switch self {
        case .checkDuplicateNickname:
            return "/api/v1/members/validate-nickname"
        case .fetchProfessionFields:
            return "/api/v1/professions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkDuplicateNickname:
            return .get
        case .fetchProfessionFields:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .checkDuplicateNickname(let nicknameRequestDTO):
            guard let dto = nicknameRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
            
        case .fetchProfessionFields:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(PrototypeAPIConst.getToken())",
            "Content-Type": "application/json"
        ]
    }
}
