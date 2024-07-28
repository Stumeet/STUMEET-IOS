//
//  StudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

protocol StudyActivityRepository {
    func fetchAllActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never>
    func fetchGroupActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never>
    func fetchTaskActivityItems(size: Int, page: Int) -> AnyPublisher<[Activity], Never>
}
