//
//  DetailStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

protocol DetailStudyActivityRepository {
    func fetchDetailActivityItems(studyID: Int, activityID: Int) -> AnyPublisher<[DetailStudyActivitySectionItem], Never>
}
