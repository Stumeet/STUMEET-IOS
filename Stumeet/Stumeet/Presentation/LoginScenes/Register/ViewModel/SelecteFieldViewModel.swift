//
//  SelecteFieldViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Combine
import Foundation

final class SelecteFieldViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectField: AnyPublisher<IndexPath, Never>
        let didSearchField: AnyPublisher<String?, Never>
        let didSelectSearchedField: AnyPublisher<IndexPath, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let fieldItems: AnyPublisher<[Field], Never>
        let searchedItems: AnyPublisher<[AddableField], Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    let useCase: SelectFieldUseCase
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(useCase: SelectFieldUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let addFieldItem = input.didSelectSearchedField
            .flatMap { [weak self] indexPath -> AnyPublisher<[Field], Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.useCase.addField(at: indexPath)
            }
        
        let fieldItems =
        input.didSelectField
            .flatMap { [weak self] indexPath -> AnyPublisher<[Field], Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.useCase.selectField(at: indexPath)
            }
            .merge(with: useCase.getFields(), addFieldItem)
            .eraseToAnyPublisher()
        
        let searchedItems = input.didSearchField
            .compactMap { $0 }
            .flatMap { [weak self] text -> AnyPublisher<[AddableField], Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.useCase.getSearchedField(text: text)
            }
            .eraseToAnyPublisher()
        
        let isNextButtonEnable = fieldItems
            .map { $0.contains { $0.isSelected } }
            .eraseToAnyPublisher()
        
        return Output(
            fieldItems: fieldItems,
            searchedItems: searchedItems,
            isNextButtonEnabled: isNextButtonEnable
        )
    }
}
