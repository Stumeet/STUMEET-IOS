//
//  StudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

protocol StudyActivityRepository {
    func fetchActivityItems(type: StudyActivitySectionItem) -> AnyPublisher<[StudyActivitySectionItem], Never>
}
