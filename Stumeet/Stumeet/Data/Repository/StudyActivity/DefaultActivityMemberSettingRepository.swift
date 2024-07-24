//
//  DefaultActivityMemberSettingRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/17/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class DefaultActivityMemberSettingRepository: ActivityMemberSettingRepository {
    
    private let provider: MoyaProvider<StudyMemberService>
    
    init(provider: MoyaProvider<StudyMemberService>) {
        self.provider = provider
    }
    
    // TODO: - id 변경, error 처리
    
    func fetchMembers() -> AnyPublisher<[ActivityMember], Never> {
        let requestDTO = StudyMemberRequestDTO(studyId: 1)
        return provider.requestPublisher(.fetchStudyMembers(requestDTO))
            .map(ResponseWithDataDTO<StudyMemberResponseDTO>.self)
            .compactMap { $0.data?.studyMembers.map { $0.toDomain() } }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
