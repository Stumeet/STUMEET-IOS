//
//  DefaultStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import CombineMoya
import Moya

final class DefaultStudyActivityRepository: StudyActivityRepository {
    
    private let provider: MoyaProvider<ActivityListService>
    
    init(provider: MoyaProvider<ActivityListService>) {
        self.provider = provider
    }
    
    func fetchActivityItems(type: StudyActivitySectionItem) -> AnyPublisher<[Activity], Never> {
        // TODO: - 페이징 구현, 에러 처리
        switch type {
        
        case .all:
            let requestDTO = AllStudyActivityRequestDTO(
                size: 4,
                page: 0,
                isNotice: false,
                studyId: 1,
                category: nil
            )
            
            return provider.requestPublisher(.fetchAllActivities(requestDTO))
                .map(ResponseWithDataDTO<AllStudyActivityResponseDTO>.self)
                .compactMap { $0.data?.items.map { $0.toDomain() } }
                .replaceError(with: [])
                .eraseToAnyPublisher()
            
            
        case .group:
            let requestDTO = BriefStudyActivityRequestDTO(
                size: 9,
                page: 0,
                isNotice: false,
                studyId: 1,
                category: "MEET",
                fromDate: nil,
                toDate: nil
            )
            
            return provider.requestPublisher(.fetchBriefActivities(requestDTO))
                .map(ResponseWithDataDTO<BreifStudyActivityResponseDTO>.self)
                .compactMap { $0.data?.items.map { $0.toDomain() } }
                .replaceError(with: [])
                .eraseToAnyPublisher()
            
        case .task:
            let requestDTO = BriefStudyActivityRequestDTO(
                size: 9,
                page: 0,
                isNotice: false,
                studyId: 1,
                category: "ASSIGNMENT",
                fromDate: nil,
                toDate: nil
            )
            
            return provider.requestPublisher(.fetchBriefActivities(requestDTO))
                .map(ResponseWithDataDTO<BreifStudyActivityResponseDTO>.self)
                .compactMap { $0.data?.items.map { $0.toDomain() } }
                .replaceError(with: [])
                .eraseToAnyPublisher()
        }
    }
}
