//
//  SelectStudyGroupFieldViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//


import Combine
import Foundation

final class SelectStudyGroupFieldViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectedField: AnyPublisher<IndexPath, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyFieldSectionItem], Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completeField: AnyPublisher<StudyField, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: SelectStudyGroupFieldUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: SelectStudyGroupFieldUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let fieldSubject = CurrentValueSubject<[StudyField], Never>([])
        
        useCase.getFieldItems()
            .sink(receiveValue: fieldSubject.send)
            .store(in: &cancellables)
        
        let items = fieldSubject
            .map { $0.map { StudyFieldSectionItem.fieldCell($0) } }
            .eraseToAnyPublisher()
        
        input.didSelectedField
            .map { ($0, fieldSubject.value) }
            .flatMap(useCase.getSelectedFields)
            .sink(receiveValue: fieldSubject.send)
            .store(in: &cancellables)
        
        let isEnable = fieldSubject
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let completeField = input.didTapCompleteButton
            .map { fieldSubject.value }
            .flatMap(useCase.getSelectedField)
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            isEnableCompleteButton: isEnable,
            completeField: completeField
        )
    }
}
