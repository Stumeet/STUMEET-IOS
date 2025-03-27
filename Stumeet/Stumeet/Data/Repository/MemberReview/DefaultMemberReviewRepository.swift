//
//  DefaultMemberReviewRepository.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Moya
import CombineMoya
import Combine

final class DefaultMemberReviewRepository: MemberReviewRepository {
    
    private let provider: MoyaProvider<MemberReviewService>
    
    init(provider: MoyaProvider<MemberReviewService>) {
        self.provider = provider
    }
    
    func fetchMemberReviewTagStats() -> AnyPublisher<(Int, [ReviewTag]), MoyaError> {
        return provider.requestPublisher(.fetchMemberReviewTagStats)
            .map(ResponseWithDataDTO<FetchMemberReviewTagStatsResponseDTO>.self)
            .compactMap { $0.data?.toDomain() }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
