//
//  UserTokenService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/01.
//

import Moya

enum UserTokenService {
    case tokens(TokensRequestDTO)
}

extension UserTokenService:
    BaseTargetType {

    var path: String {
        switch self {
        case .tokens:
            return "/api/v1/tokens"
        }
    }
    
    var method: Method {
        switch self {
        case .tokens:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .tokens(let tokensRequestDTO):
            guard let dto = tokensRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
