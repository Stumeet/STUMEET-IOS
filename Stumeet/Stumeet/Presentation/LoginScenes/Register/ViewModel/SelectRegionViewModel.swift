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
    private var regionsSubject = CurrentValueSubject<[Region], Never>(Region.list)
    
    // MARK: - Init
    init() { }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        // 선택 이벤트 처리
        input.didSelectItem
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                var newRegions = self.regionsSubject.value
                for idx in 0..<newRegions.count {
                    newRegions[idx].isSelected = idx == indexPath.row
                }
                self.regionsSubject.send(newRegions)
            }
            .store(in: &cancellables)
        
        let navigateToField = input.didTapNextButton
        
        let regionItems = regionsSubject.eraseToAnyPublisher()
        
        let isNextButtonEnabled = regionsSubject
            .map { $0.contains { $0.isSelected } }
            .eraseToAnyPublisher()
        
        return Output(
            regionItems: regionItems,
            isNextButtonEnabled: isNextButtonEnabled,
            navigateToSelectFieldVC: navigateToField
        )
    }
}
