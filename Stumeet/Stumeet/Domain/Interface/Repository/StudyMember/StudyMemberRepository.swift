//
//  StudyMemberRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/25.
//

import Combine
import Moya

protocol StudyMemberRepository {
    func fetchStudyMembers(studyID: Int) -> AnyPublisher<[StudyMember], MoyaError>
    func checkIfAdmin(studyID: Int) -> AnyPublisher<Bool, MoyaError>
    func fetchStudyMemberDetailInfo(studyID: Int, memberID: Int) -> AnyPublisher<StudyMember, MoyaError>
}
