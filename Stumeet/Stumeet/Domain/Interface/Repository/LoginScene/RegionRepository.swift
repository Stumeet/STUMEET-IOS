//
//  RegionRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

protocol RegionRepository {
    func fetchRegions() -> AnyPublisher<[Region], Never>
    func selectRegion(at indexPath: IndexPath) -> AnyPublisher<[Region], Never>
}
