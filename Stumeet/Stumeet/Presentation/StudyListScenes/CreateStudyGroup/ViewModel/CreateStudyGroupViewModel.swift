//
//  CreateStudyGroupViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

final class CreateStudyGroupViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapFieldButton: AnyPublisher<Void, Never>
        let didSelectedField: AnyPublisher<StudyField, Never>
        let didChangedTagTextField: AnyPublisher<String?, Never>
        let didTapAddTagButton: AnyPublisher<Void, Never>
        let didTapTagXButton: AnyPublisher<String, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let goToSelectStudyGroupFieldVC: AnyPublisher<Void, Never>
        let selectedField: AnyPublisher<StudyField, Never>
        let isEnableTagAddButton: AnyPublisher<Bool, Never>
        let addedTags: AnyPublisher<[CreateStudyTagSectionItem], Never>
        let isEmptyTags: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: CreateStudyGroupUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: CreateStudyGroupUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let tagTextSubject = CurrentValueSubject<String, Never>("")
        let addedTagsSubject = CurrentValueSubject<[String], Never>([])
        
        input.didChangedTagTextField
            .compactMap { $0 }
            .sink(receiveValue: tagTextSubject.send)
            .store(in: &cancellables)
        
        let isEnableTagAddButton = tagTextSubject
            .flatMap(useCase.getIsEnableTagAddButton)
            .eraseToAnyPublisher()
        
        input.didTapAddTagButton
            .map { (addedTagsSubject.value, tagTextSubject.value) }
            .flatMap(useCase.addTag)
            .sink(receiveValue: addedTagsSubject.send)
            .store(in: &cancellables)
        
        let isEmptyTags = addedTagsSubject
            .map { $0.isEmpty }.eraseToAnyPublisher()
        
        input.didTapTagXButton
            .map { (addedTagsSubject.value, $0) }
            .flatMap(useCase.removeTag)
            .sink(receiveValue: addedTagsSubject.send)
            .store(in: &cancellables)
        
        let addedTags = addedTagsSubject
            .removeDuplicates()
            .map { $0.map { CreateStudyTagSectionItem.tagCell($0) } }
            .eraseToAnyPublisher()
        
        
        return Output(
            goToSelectStudyGroupFieldVC: input.didTapFieldButton,
            selectedField: input.didSelectedField,
            isEnableTagAddButton: isEnableTagAddButton,
            addedTags: addedTags,
            isEmptyTags: isEmptyTags
        )
    }
}
