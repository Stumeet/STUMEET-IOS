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
        let didSelectedField: AnyPublisher<SelectStudyItem, Never>
        let didChangedTagTextField: AnyPublisher<String?, Never>
        let didTapAddTagButton: AnyPublisher<Void, Never>
        let didTapTagXButton: AnyPublisher<String, Never>
        let didTapRegionButton: AnyPublisher<Void, Never>
        let didSelectedRegion: AnyPublisher<SelectStudyItem, Never>
        let didTapPeriodStartButton: AnyPublisher<Void, Never>
        let didTapPeriodEndButton: AnyPublisher<Void, Never>
        let didSelecetedPeriod: AnyPublisher<(startDate: Date, endDate: Date), Never>
        let didTapTimeButton: AnyPublisher<Void, Never>
        let didSelectedTime: AnyPublisher<String, Never>
        let didTapRepeatButton: AnyPublisher<Void, Never>
        let didSelectedRepeatDays: AnyPublisher<StudyRepeatType, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let goToSelectStudyGroupFieldVC: AnyPublisher<CreateStudySelectItemType, Never>
        let selectedField: AnyPublisher<SelectStudyItem, Never>
        let isEnableTagAddButton: AnyPublisher<Bool, Never>
        let addedTags: AnyPublisher<[CreateStudyTagSectionItem], Never>
        let isEmptyTags: AnyPublisher<Bool, Never>
        let goToSelectStudyGroupRegionVC: AnyPublisher<CreateStudySelectItemType, Never>
        let selectedRegion: AnyPublisher<SelectStudyItem, Never>
        let goToSetStudyGroupPeriodVC: AnyPublisher<(isStart: Bool, startDate: Date, endDate: Date?), Never>
        let periodAttributedStrings: AnyPublisher<(start: AttributedString, end: AttributedString?), Never>
        let goToSelectStudyTimeVC: AnyPublisher<Void, Never>
        let timeAttributedString: AnyPublisher<AttributedString, Never>
        let goToSelectStudyRepeatVC: AnyPublisher<Void, Never>
        let selectedRepeatDays: AnyPublisher<StudyRepeatType, Never>
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
        let periodDateSubject = CurrentValueSubject<(startDate: Date, endDate: Date?), Never>((useCase.getCurrentDate(), nil))
        
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
        
        let goToSelectStudyGroupFieldVC = input.didTapFieldButton
            .map { CreateStudySelectItemType.field }
            .eraseToAnyPublisher()
        
        let goToSelectStudyGroupRegionVC = input.didTapRegionButton
            .map { CreateStudySelectItemType.region }
            .eraseToAnyPublisher()
        
        let goToSetStudyGroupPeriodVC = Publishers.Merge(
            input.didTapPeriodStartButton.map { true },
            input.didTapPeriodEndButton.map { false }
        )
            .map { (isStart: $0, startDate: periodDateSubject.value.startDate, endDate: periodDateSubject.value.endDate) }
            .eraseToAnyPublisher()

        input.didSelecetedPeriod
            .sink(receiveValue: periodDateSubject.send)
            .store(in: &cancellables)
        
        let periodAttributedStrings = periodDateSubject
            .map(dateToAttributedString)
            .eraseToAnyPublisher()
        
        let timeAttributedString = input.didSelectedTime
            .map { AttributedString($0) }
            .eraseToAnyPublisher()
        
        return Output(
            goToSelectStudyGroupFieldVC: goToSelectStudyGroupFieldVC,
            selectedField: input.didSelectedField,
            isEnableTagAddButton: isEnableTagAddButton,
            addedTags: addedTags,
            isEmptyTags: isEmptyTags,
            goToSelectStudyGroupRegionVC: goToSelectStudyGroupRegionVC,
            selectedRegion: input.didSelectedRegion,
            goToSetStudyGroupPeriodVC: goToSetStudyGroupPeriodVC,
            periodAttributedStrings: periodAttributedStrings,
            goToSelectStudyTimeVC: input.didTapTimeButton,
            timeAttributedString: timeAttributedString,
            goToSelectStudyRepeatVC: input.didTapRepeatButton,
            selectedRepeatDays: input.didSelectedRepeatDays.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Function
    
    private func dateToAttributedString(start: Date, end: Date?) -> (start: AttributedString, end: AttributedString?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy,M.d"
        
        let startAttributedString = AttributedString(dateFormatter.string(from: start))
        guard let end = end else { return (startAttributedString, nil) }
        let endAttributedString = AttributedString(dateFormatter.string(from: end))
        
        return (startAttributedString, endAttributedString)
        
    }
}
