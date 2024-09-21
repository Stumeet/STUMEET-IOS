//
//  CreateStudyGroupRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 8/26/24.
//

import Foundation

import Combine

protocol CreateStudyGroupRepository {
    func postCreateStudyGroup(data: CreateStudyGroup) -> AnyPublisher<Bool, Never>
}
