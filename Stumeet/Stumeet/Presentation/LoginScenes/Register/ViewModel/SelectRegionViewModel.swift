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
        let navigateToSelectFieldVC: AnyPublisher<Register, Never>
    }
    
    // MARK: - Properties
    private let useCase: SelectRegionUseCase
    private var register: Register
    private let regionItemSubject = CurrentValueSubject<[Region], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(useCase: SelectRegionUseCase, register: Register) {
        self.useCase = useCase
        self.register = register
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        // Input
        let regionItems = regionItemSubject.eraseToAnyPublisher()
        
        useCase.getRegions()
            .sink(receiveValue: regionItemSubject.send)
            .store(in: &cancellables)

        input.didSelectItem
            .flatMap(useCase.selectRegion)
            .sink(receiveValue: { [weak self] regions in
                let region = regions.filter { $0.isSelected }
                    .map { $0.region }
                    .joined()
                
                self?.register.region = region
                self?.regionItemSubject.send(regions)
            })
            .store(in: &cancellables)
        
        let navigateToField = input.didTapNextButton
            .flatMap { [weak self] _ in
                Just(self?.register)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
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
