//
//  SelecteStudyGroupFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

protocol SelectStudyGroupItemRepository {
    func getFieldItems() -> AnyPublisher<[SelectStudyItem], Never>
    func getRegionItems() -> AnyPublisher<[SelectStudyItem], Never>
}
