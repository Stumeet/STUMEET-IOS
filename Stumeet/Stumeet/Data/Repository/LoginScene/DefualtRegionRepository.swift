//
//  DefualtRegionRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

class DefaultRegionRepository: RegionRepository {
    
    private var regions: [Region] = Region.list
    private var regionsSubject = CurrentValueSubject<[Region], Never>(Region.list)
    
    func fetchRegions() -> AnyPublisher<[Region], Never> {
        return regionsSubject.eraseToAnyPublisher()
    }
    
    func selectRegion(at indexPath: IndexPath) -> AnyPublisher<[Region], Never> {
        for (index, _) in regions.enumerated() {
            regions[index].isSelected = index == indexPath.row
        }
        regionsSubject.send(regions)
        return regionsSubject.eraseToAnyPublisher()
    }
}
