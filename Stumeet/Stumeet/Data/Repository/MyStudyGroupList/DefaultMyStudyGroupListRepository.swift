//
//  DefaultMyStudyGroupListRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/07.
//

import Moya
import CombineMoya
import Combine

final class DefaultMyStudyGroupListRepository: MyStudyGroupListRepository {
    private let provider: MoyaProvider<StudyService>
    
    init(provider: MoyaProvider<StudyService>) {
        self.provider = provider
    }

    func fetchJoinedStudyGroups(type: String) -> AnyPublisher<[StudyGroup], MoyaError> {
        let requestDTO = StudiesRequestDTO(status: type)
        return provider.requestPublisher(.listJoinedStudyGroups(requestDTO))
            .map(ResponseWithDataDTO<StudiesResponseDTO>.self)
            .map { response -> [StudyGroup] in
                guard let data = response.data?.studySimpleResponses else { return [] }
                let list = data.map { $0.toDomain() }                
                return list
            }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
