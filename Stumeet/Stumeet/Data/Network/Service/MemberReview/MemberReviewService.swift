//
//  MemberReviewService.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Moya

enum MemberReviewService {
//    case registerReview   // 리뷰 등록
    // TODO: 응답에서 페이지 정보가 없음 서버측 질문 후 다시 작업
    case fetchMemberReview(FetchMemberReviewRequestDTO)   // 멤버 리뷰 조회
    case fetchMemberReviewTagStats    // 멤버 리뷰 태그 개수 통계 조회
//    case sendPraise   // 포도알 칭찬 전송
//    case fetchPraiseList  // 포도알 칭찬 목록 조회
}

extension MemberReviewService: BaseTargetType {

    var path: String {
        switch self {
        case .fetchMemberReview:
            return "/api/v1/reviews"
        case .fetchMemberReviewTagStats:
            return "/api/v1/reviews/tags/stats"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchMemberReview, .fetchMemberReviewTagStats:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMemberReview(let requestDTO):
            guard let dto = requestDTO.toDictionary else { return .requestPlain}
            return .requestParameters(parameters: dto, encoding: URLEncoding.queryString)
        case .fetchMemberReviewTagStats:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}

