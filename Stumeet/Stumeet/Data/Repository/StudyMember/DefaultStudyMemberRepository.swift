//
//  DefaultStudyMemberRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/25.
//

import Moya
import CombineMoya
import Combine

final class DefaultStudyMemberRepository: StudyMemberRepository {
    private let provider: MoyaProvider<StudyMemberService>
    
    init(provider: MoyaProvider<StudyMemberService>) {
        self.provider = provider
    }
    
    func fetchStudyMembers(studyID: Int) -> AnyPublisher<[StudyMember], MoyaError> {
        let requestDTO = StudyMemberRequestDTO(studyId: studyID)
        return provider.requestPublisher(.fetchStudyMembers(requestDTO))
            .map(ResponseWithDataDTO<StudyMemberResponseDTO>.self)
            .compactMap { $0.data?.studyMembers.map { $0.toDomainForStudyMember() } }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
