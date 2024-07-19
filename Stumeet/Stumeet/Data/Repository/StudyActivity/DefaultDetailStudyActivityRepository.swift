//
//  DefaultDetailStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class DefaultDetailStudyActivityRepository: DetailStudyActivityRepository {
    
    // TODO: - error 처리
    
    private let provider: MoyaProvider<ActivityService>
    
    init(provider: MoyaProvider<ActivityService>) {
        self.provider = provider
    }
    
    func fetchDetailActivityItems(studyID: Int, activityID: Int) -> AnyPublisher<DetailStudyActivity, Never> {
        let requestDTO = DetailActivityRequestDTO(
            studyId: studyID,
            activityId: activityID
        )
        
        return provider.requestPublisher(.fetchDetailActivity(requestDTO))
            .map(ResponseWithDataDTO<DetailActivityResponseDTO>.self)
            .compactMap { $0.data?.toDomain() }
            .replaceError(with: nil)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
