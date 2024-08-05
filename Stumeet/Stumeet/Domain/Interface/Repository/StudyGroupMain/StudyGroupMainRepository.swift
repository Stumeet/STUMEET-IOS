//
//  StudyGroupMainRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Combine
import Moya

protocol StudyGroupMainRepository {
    func fetchDetailStudyGroupInfo(studyId: Int) -> AnyPublisher<StudyGroupDetail, MoyaError>
}
