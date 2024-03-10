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
        let didTapNextButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let fieldItems: AnyPublisher<[Field], Never>
        let searchedItems: AnyPublisher<[Field], Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let presentToStartVC: AnyPublisher<Register, Never>
    }
    
    // MARK: - Properties
    
    let useCase: SelectFieldUseCase
    var register: Register
    private var cancellables = Set<AnyCancellable>()
    private let fieldItemSubject = CurrentValueSubject<[Field], Never>([])
    
    // MARK: - Init
    
    init(useCase: SelectFieldUseCase, register: Register) {
        self.useCase = useCase
        self.register = register
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let fieldItems = fieldItemSubject.eraseToAnyPublisher()
        
        useCase.getFields()
            .sink(receiveValue: fieldItemSubject.send)
            .store(in: &cancellables)
        
        input.didSelectSearchedField
            .flatMap(useCase.addField)
            .sink(receiveValue: fieldItemSubject.send)
            .store(in: &cancellables)
        
        input.didSelectField
            .flatMap(useCase.selectField)
            .sink(receiveValue: { [weak self] fields in
                let field = fields.filter { $0.isSelected }
                    .map { $0.name }
                    .joined()
                
                self?.register.field = field
                self?.fieldItemSubject.send(fields)
            })
            .store(in: &cancellables)
        
        let searchedItems = input.didSearchField
            .compactMap { $0 }
            .flatMap(useCase.fetchSearchedField)
            .eraseToAnyPublisher()
        
        let isNextButtonEnable = fieldItems
            .map { $0.contains { $0.isSelected } }
            .eraseToAnyPublisher()
        
        let presentToStartVC = input.didTapNextButton
            .flatMap { Just(self.register) }
            .eraseToAnyPublisher()
        
        return Output(
            fieldItems: fieldItems,
            searchedItems: searchedItems,
            isNextButtonEnabled: isNextButtonEnable,
            presentToStartVC: presentToStartVC
        )
    }
}
