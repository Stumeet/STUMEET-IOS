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
    private var cancellables = Set<AnyCancellable>()
    private let useCase: SelectRegionUseCase
    
    // MARK: - Init
    init(useCase: SelectRegionUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        // input
        let didSelectItem = input.didSelectItem

        let navigateToField = input.didTapNextButton
        
        // Output
        let regionItems = useCase.getRegions()
        
        let isNextButtonEnabled = regionItems
            .map { $0.contains { $0.isSelected } }
            .eraseToAnyPublisher()
        
        didSelectItem
            .map { [weak self] indexPath in
                self?.useCase.selectRegion(at: indexPath)
            }
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)
        
        return Output(
            regionItems: regionItems,
            isNextButtonEnabled: isNextButtonEnabled,
            navigateToSelectFieldVC: navigateToField
        )
    }
}
