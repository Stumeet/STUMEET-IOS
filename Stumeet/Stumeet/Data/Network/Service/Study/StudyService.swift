//
//  StudyService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/07.
//

import Moya
import Foundation

enum StudyService {
    case detailStudyGroupsInfo(_ studyId: Int) // 스터디 상세 정보 조회
    case listJoinedStudyGroups(StudiesRequestDTO) // 가입 스터디 리스트 조회
    case createStudyGroup(CreateStudyGroupRequestDTO)
}

extension StudyService: BaseTargetType {

    var path: String {
        switch self {
        case .detailStudyGroupsInfo(let studyId):
            return "/api/v1/studies/\(studyId)"
        case .listJoinedStudyGroups, .createStudyGroup:
            return "/api/v1/studies"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .detailStudyGroupsInfo, .listJoinedStudyGroups:
            return .get
        case .createStudyGroup:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .detailStudyGroupsInfo:
            return .requestPlain
        case .listJoinedStudyGroups(let studiesRequestDTO):
            guard let dto = studiesRequestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
        case .createStudyGroup(let requestDTO):
            var multipartData: [MultipartFormData] = []
            
            // 이미지 데이터가 있는 경우, 이를 multipartData 배열에 추가
            if let imageData = requestDTO.image {
                let imageMultipart = MultipartFormData(
                    provider: .data(imageData),
                    name: "mainImageFile",
                    fileName: "mainImageFile.jpg",
                    mimeType: "image/jpeg"
                )
                multipartData.append(imageMultipart)
            }
            
            // DTO 데이터를 JSON으로 인코딩하여 "request" 필드에 추가
            if let dtoData = try? JSONEncoder().encode(requestDTO) {
                let jsonMultipart = MultipartFormData(
                    provider: .data(dtoData),
                    name: "request",
                    mimeType: "application/json"
                )
                multipartData.append(jsonMultipart)
            }
            
            // 전체 Multipart 요청을 반환
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createStudyGroup:
            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }

}
