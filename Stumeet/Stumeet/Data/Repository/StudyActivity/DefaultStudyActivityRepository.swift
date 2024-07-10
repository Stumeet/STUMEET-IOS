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
    
    func fetchAllActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never> {
        // TODO: - 페이징 구현, 에러 처리, id 변경
        
        let requestDTO = AllStudyActivityRequestDTO(
            size: size,
            page: page,
            isNotice: false,
            studyId: 1,
            category: nil
        )
        
        return provider.requestPublisher(.fetchAllActivities(requestDTO))
            .map(ResponseWithDataDTO<AllStudyActivityResponseDTO>.self)
            .compactMap { $0.data?.items.map { $0.toDomain() } }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
            
    func fetchGroupActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never> {
        
        let requestDTO = BriefStudyActivityRequestDTO(
            size: size,
            page: page,
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
    }
    func fetchTaskActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never> {
        let requestDTO = BriefStudyActivityRequestDTO(
            size: size,
            page: page,
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
