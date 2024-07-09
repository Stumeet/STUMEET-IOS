//
//  MyStudyGroupListRepository.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/07.
//

import Combine
import Moya

protocol MyStudyGroupListRepository {
    func fetchJoinedStudyGroups(type: String) -> AnyPublisher<[StudyGroup], MoyaError>
}
