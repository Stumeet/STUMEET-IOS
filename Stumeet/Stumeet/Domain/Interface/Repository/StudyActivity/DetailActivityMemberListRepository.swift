//
//  DetailActivityMemberListRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

protocol DetailActivityMemberListRepository {
    func fetchMembers(studyID: Int, activityID: Int) -> AnyPublisher<[DetailActivityMember], Never>
}
