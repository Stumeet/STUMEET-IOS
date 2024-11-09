//
//  SelectStudyItemViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//


import Combine
import Foundation

final class SelectStudyItemViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectedItem: AnyPublisher<IndexPath, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[SelectStudySectionItem], Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completeItem: AnyPublisher<(SelectStudyItem, CreateStudySelectItemType), Never>
    }
    
    // MARK: - Properties
    
    private let useCase: SelectStudyGroupItemUseCase
    let itemType: CreateStudySelectItemType
    private let selectedItem: String
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: SelectStudyGroupItemUseCase, type: CreateStudySelectItemType, selectedItem: String) {
        self.useCase = useCase
        self.itemType = type
        self.selectedItem = selectedItem
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let itemSubject = CurrentValueSubject<[SelectStudyItem], Never>([])
        
        useCase.getItems(type: itemType, selectedItem: selectedItem)
            .sink(receiveValue: itemSubject.send)
            .store(in: &cancellables)
        
        let items = itemSubject
            .map { $0.map { SelectStudySectionItem.itemCell($0) } }
            .eraseToAnyPublisher()
        
        input.didSelectedItem
            .map { ($0, itemSubject.value) }
            .flatMap(useCase.getSelectedItems)
            .sink(receiveValue: itemSubject.send)
            .store(in: &cancellables)
        
        let isEnable = itemSubject
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let completeItem = input.didTapCompleteButton
            .map { (itemSubject.value) }
            .flatMap(useCase.getSelectedItem)
            .map { ($0, self.itemType) }
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            isEnableCompleteButton: isEnable,
            completeItem: completeItem
        )
    }
}
