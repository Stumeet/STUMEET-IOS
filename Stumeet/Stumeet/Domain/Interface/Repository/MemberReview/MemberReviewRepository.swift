//
//  MemberReviewRepository.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Combine
import Moya

protocol MemberReviewRepository {
    func fetchMemberReviewTagStats() -> AnyPublisher<(Int, [ReviewTag]), MoyaError>
}
