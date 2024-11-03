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
    
    func checkIfAdmin(studyID: Int) -> AnyPublisher<Bool, MoyaError> {
        let requestDTO = StudyMemberRequestDTO(studyId: studyID)
        
        return provider.requestPublisher(.adminCheck(requestDTO))
            .map(ResponseWithDataDTO<StudyMemberAdminResponseDTO>.self)
            .compactMap { $0.data?.isAdmin }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func fetchStudyMemberDetailInfo(studyID: Int, memberID: Int) -> AnyPublisher<StudyMember, MoyaError> {
        let requestDTO = StudyMemberDetailRequestDTO(studyId: studyID, memberId: memberID)
        
        return provider.requestPublisher(.fetchStudyMemberDetailInfo(requestDTO))
            .map(ResponseWithDataDTO<StudyMemberDetailResponseDTO>.self)
            .compactMap { $0.data?.toDomain() }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func removeStudyMember(studyID: Int, memberID: Int) -> AnyPublisher<Bool, MoyaError> {
        let requestDTO = StudyMemberRemoveRequestDTO(studyId: studyID, memberId: memberID)
        
        return provider.requestPublisher(.removeStudyMember(requestDTO))
            .map(ResponseWithDataDTO<Bool>.self)
            .compactMap { $0.code == 200 }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func delegateAdminRights(studyID: Int, memberID: Int) -> AnyPublisher<Bool, MoyaError> {
        let requestDTO = StudyAdminDelegateRequestDTO(studyId: studyID, memberId: memberID)
        
        return provider.requestPublisher(.delegateAdminRights(requestDTO))
            .map(ResponseWithDataDTO<Bool>.self)
            .compactMap { $0.code == 200 }
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
