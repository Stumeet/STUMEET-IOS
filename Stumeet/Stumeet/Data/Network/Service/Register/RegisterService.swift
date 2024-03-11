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
    case signUp(Data, RegisterRequestDTO)
}

extension RegisterService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL { return URL(string: "https://stumeet.shop")! }
    
    var path: String {
        switch self {
        case .checkDuplicateNickname:
            return "/api/v1/members/validate-nickname"
        case .fetchProfessionFields:
            return "/api/v1/professions"
        case .signUp:
            return "/api/v1/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkDuplicateNickname:
            return .get
        case .fetchProfessionFields:
            return .get
        case .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkDuplicateNickname(let nicknameRequestDTO):
            guard let dto = nicknameRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
            
        case .fetchProfessionFields:
            return .requestPlain
            
        case .signUp(let imageData, let registerRequestDTO):
            
            let imageData = MultipartFormData(provider: .data(imageData), name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            
            guard let dto = registerRequestDTO.toDictionary else { return .requestPlain }
            
            return .uploadCompositeMultipart([imageData], urlParameters: dto)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signUp:
            return [
                "Content-type": "multipart/form-data",
                "Authorization": "Bearer \(PrototypeAPIConst.getToken())"
            ]
        default:
            return [
                "Authorization": "Bearer \(PrototypeAPIConst.getToken())",
                "Content-Type": "application/json"
            ]
        }
    }
}
