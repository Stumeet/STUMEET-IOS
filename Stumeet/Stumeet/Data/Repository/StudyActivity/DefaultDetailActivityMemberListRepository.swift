//
//  DefaultDetailActivityMemberListRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class DefaultDetailActivityMemberListRepository: DetailActivityMemberListRepository {
    
    private let provider: MoyaProvider<ActivityService>
    
    init(provider: MoyaProvider<ActivityService>) {
        self.provider = provider
    }
    
    func fetchMembers(studyID: Int, activityID: Int) -> AnyPublisher<[DetailActivityMember], Never> {
        
        let requestDTO = DetailActivityRequestDTO(studyId: studyID, activityId: activityID)
        
        return provider.requestPublisher(.fetchDetailActivityMember(requestDTO))
            .map(ResponseWithDataDTO<DetailActivityMemberResponseDTO>.self)
            .compactMap { $0.data.map { $0.toDomain() } }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
