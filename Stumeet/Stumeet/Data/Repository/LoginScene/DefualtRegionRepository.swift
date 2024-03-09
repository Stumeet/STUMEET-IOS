//
//  DefualtRegionRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

class DefaultRegionRepository: RegionRepository {
    
    private var regionsSubject = CurrentValueSubject<[Region], Never>(Region.list)
    
    func fetchRegions() -> AnyPublisher<[Region], Never> {
        return regionsSubject.eraseToAnyPublisher()
    }
    
    func updateRegions(regions: [Region]) {
        regionsSubject.send(regions)
    }
}
