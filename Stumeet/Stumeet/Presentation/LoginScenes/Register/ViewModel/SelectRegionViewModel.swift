//
//  SelectRegionViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import Combine
import Foundation

final class SelectRegionViewModel: ViewModelType {
    
    // MARK: - Input
    struct Input {
        let didSelectItem: AnyPublisher<IndexPath, Never>
        let didTapNextButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    struct Output {
        let regionItems: AnyPublisher<[Region], Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let navigateToSelectFieldVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    private let useCase: SelectRegionUseCase
    private let register: Register
    
    // MARK: - Init
    init(useCase: SelectRegionUseCase, register: Register) {
        self.useCase = useCase
        self.register = register
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        // Input
        let regionItems = input.didSelectItem
            .flatMap { [weak self] indexPath -> AnyPublisher<[Region], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.useCase.selectRegion(at: indexPath)
            }
            .merge(with: useCase.getRegions())
            .eraseToAnyPublisher()
        
        let navigateToField = input.didTapNextButton
        
        let isNextButtonEnabled = regionItems
            .map { $0.contains { $0.isSelected } }
            .eraseToAnyPublisher()
        
        // Output
        return Output(
            regionItems: regionItems,
            isNextButtonEnabled: isNextButtonEnabled,
            navigateToSelectFieldVC: navigateToField
        )
    }
}
