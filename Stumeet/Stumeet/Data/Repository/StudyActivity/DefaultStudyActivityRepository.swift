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
    
    private let provider: MoyaProvider<ActivityService>
    
    init(provider: MoyaProvider<ActivityService>) {
        self.provider = provider
    }
    
    func fetchAllActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never> {
        // TODO: - 에러 처리, id 변경
        
        let requestDTO = AllStudyActivityRequestDTO(
            size: size,
            page: page,
            isNotice: nil,
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
            isNotice: nil,
            studyId: 1,
            category: ActivityCategory.meeting.rawValue,
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
            isNotice: nil,
            studyId: 1,
            category: ActivityCategory.homework.rawValue,
            fromDate: nil,
            toDate: nil
        )
        
        return provider.requestPublisher(.fetchBriefActivities(requestDTO))
            .map(ResponseWithDataDTO<BreifStudyActivityResponseDTO>.self)
            .compactMap { $0.data?.items.map { $0.toDomain() } }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    // TODO: - 임시: 스터디 그룹 메인용
    func fetchActivityDetailItems(
        size: Int,
        page: Int,
        isNotice: Bool?,
        studyId: Int?,
        category: String?
    ) -> AnyPublisher<ActivityPage, MoyaError> {
        let requestDTO = AllStudyActivityRequestDTO(
            size: size,
            page: page,
            isNotice: isNotice,
            studyId: studyId,
            category: category
        )
        
        return provider.requestPublisher(.fetchAllActivities(requestDTO))
            .map(ResponseWithDataDTO<AllStudyActivityResponseDTO>.self)
            .tryMap { response -> ActivityPage in
                guard let data = response.data else { throw MoyaError.requestMapping("Data is nil") }
                return data.toDomain()
            }
            .mapError { $0 as? MoyaError ?? MoyaError.underlying($0, nil) }
            .eraseToAnyPublisher()
    }
}
