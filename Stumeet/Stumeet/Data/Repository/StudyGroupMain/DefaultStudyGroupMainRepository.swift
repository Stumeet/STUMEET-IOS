//
//  DefaultStudyGroupMainRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Moya
import CombineMoya
import Combine

final class DefaultStudyGroupMainRepository: StudyGroupMainRepository {
    private let provider: MoyaProvider<StudyService>
    
    init(provider: MoyaProvider<StudyService>) {
        self.provider = provider
    }
    
    func fetchDetailStudyGroupInfo(studyId: Int) -> AnyPublisher<StudyGroupDetail, MoyaError> {
        return provider.requestPublisher(.detailStudyGroupsInfo(studyId))
            .map(ResponseWithDataDTO<StudiesDetailResponseDTO>.self)
            .tryMap { response -> StudyGroupDetail in
                guard let data = response.data else { throw MoyaError.requestMapping("Data is nil") }
                return data.toDomain()
            }
            .mapError { $0 as? MoyaError ?? MoyaError.underlying($0, nil) }
            .eraseToAnyPublisher()
    }
}
