//
//  SelectRegionUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

protocol SelectRegionUseCase {
    func getRegions() -> AnyPublisher<[Region], Never>
    func selectRegion(at indexPath: IndexPath) -> AnyPublisher<[Region], Never>
}

final class DefaultSelectRegionUseCase: SelectRegionUseCase {
    private let repository: RegionRepository
    
    init(repository: RegionRepository) {
        self.repository = repository
    }
    
    func getRegions() -> AnyPublisher<[Region], Never> {
        return repository.fetchRegions()
    }
    
    func selectRegion(at indexPath: IndexPath) -> AnyPublisher<[Region], Never> {
        return repository.fetchRegions()
            .first()
            .map { regions in
                var updatedRegions = regions
                for index in updatedRegions.indices {
                    updatedRegions[index].isSelected = updatedRegions[index] == updatedRegions[indexPath.row]
                }
                self.repository.updateRegions(regions: updatedRegions)
                return updatedRegions
            }
            .eraseToAnyPublisher()
    }
}
