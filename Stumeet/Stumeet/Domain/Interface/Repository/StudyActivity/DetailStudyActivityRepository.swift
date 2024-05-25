//
//  DetailStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

protocol DetailStudyActivityRepository {
    func fetchDetailActivityItems() -> AnyPublisher<[DetailStudyActivitySectionItem], Never>
}