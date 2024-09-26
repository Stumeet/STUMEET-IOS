//
//  CreateStudyGroupViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation
import UIKit

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
        let didTapAddImageButton: AnyPublisher<Void, Never>
        let didSelectPhoto: AnyPublisher<URL, Never>
        let didChangeStudyNameTextField: AnyPublisher<String?, Never>
        let didChangeStudyExplainTextView: AnyPublisher<String?, Never>
        let didBeginExplainEditting: AnyPublisher<Void, Never>
        let didChangeStudyRuleTextView: AnyPublisher<String?, Never>
        let didBeginStudyRuleEditting: AnyPublisher<Void, Never>
        let didTapRepeatButton: AnyPublisher<Void, Never>
        let didSelectedRepeatDays: AnyPublisher<StudyRepeatType, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
        let didTapRandomColorButton: AnyPublisher<Void, Never>
        let didTapXButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let goToSelectStudyGroupFieldVC: AnyPublisher<(CreateStudySelectItemType, String), Never>
        let selectedField: AnyPublisher<SelectStudyItem, Never>
        let isEnableTagAddButton: AnyPublisher<Bool, Never>
        let addedTags: AnyPublisher<[CreateStudyTagSectionItem], Never>
        let isEmptyTags: AnyPublisher<Bool, Never>
        let goToSelectStudyGroupRegionVC: AnyPublisher<(CreateStudySelectItemType, String), Never>
        let selectedRegion: AnyPublisher<SelectStudyItem, Never>
        let goToSetStudyGroupPeriodVC: AnyPublisher<(isStart: Bool, startDate: Date, endDate: Date?), Never>
        let periodAttributedStrings: AnyPublisher<(start: AttributedString, end: AttributedString?), Never>
        let goToSelectStudyTimeVC: AnyPublisher<Void, Never>
        let timeAttributedString: AnyPublisher<AttributedString, Never>
        let showPHPickerVC: AnyPublisher<Void, Never>
        let selectedImage: AnyPublisher<UIImage?, Never>
        let isBiggerThanTwenty: AnyPublisher<Bool, Never>
        let isBiggerThanHundredExplain: AnyPublisher<Bool, Never>
        let titleCount: AnyPublisher<Int, Never>
        let explainCount: AnyPublisher<Int, Never>
        let explainBeginText: AnyPublisher<String, Never>
        let isBiggerThanHundredRule: AnyPublisher<Bool, Never>
        let ruleCount: AnyPublisher<Int, Never>
        let ruleBeginText: AnyPublisher<String, Never>
        let goToSelectStudyRepeatVC: AnyPublisher<Void, Never>
        let selectedRepeatDays: AnyPublisher<StudyRepeatType, Never>
        let snackBarText: AnyPublisher<String, Never>
        let imageViewBackgroundColor: AnyPublisher<UIColor?, Never>
        let randomButtonColor: AnyPublisher<UIColor?, Never>
        let dismiss: AnyPublisher<Void, Never>
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
        let photoSubject = CurrentValueSubject<UIImage?, Never>(nil)
        let studyNameSubject = CurrentValueSubject<String, Never>("")
        let fieldSubject = CurrentValueSubject<String, Never>("")
        let explainSubject = CurrentValueSubject<String, Never>("")
        let regionSubject = CurrentValueSubject<String, Never>("")
        let timeSubject = CurrentValueSubject<String?, Never>(nil)
        let ruleSubject = CurrentValueSubject<String, Never>("")
        let tagTextSubject = CurrentValueSubject<String, Never>("")
        let addedTagsSubject = CurrentValueSubject<[String], Never>([])
        let periodDateSubject = CurrentValueSubject<(startDate: Date, endDate: Date?), Never>((useCase.getCurrentDate(), nil))
        let repeatTypeSubject = CurrentValueSubject<StudyRepeatType?, Never>(nil)
        let randomButtonColorSubject = CurrentValueSubject<UIColor?, Never>(StumeetColor.random.color)
        let randomBackgroundColorSubject = CurrentValueSubject<UIColor?, Never>(StumeetColor.random.color)
        
        input.didChangedTagTextField
            .compactMap { $0 }
            .sink(receiveValue: tagTextSubject.send)
            .store(in: &cancellables)
        
        let isEnableTagAddButton = tagTextSubject
            .flatMap(useCase.getIsEnableTagAddButton)
            .eraseToAnyPublisher()
        
        input.didSelectedField
            .map { $0.name }
            .sink(receiveValue: fieldSubject.send)
            .store(in: &cancellables)
        
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
            .map { (CreateStudySelectItemType.field, fieldSubject.value) }
            .eraseToAnyPublisher()
        
        let goToSelectStudyGroupRegionVC = input.didTapRegionButton
            .map { (CreateStudySelectItemType.region, regionSubject.value) }
            .eraseToAnyPublisher()
        
        input.didSelectedRegion
            .map { $0.name }
            .sink(receiveValue: regionSubject.send)
            .store(in: &cancellables)
        
        let goToSetStudyGroupPeriodVC = Publishers.Merge(
            input.didTapPeriodStartButton.map { true },
            input.didTapPeriodEndButton.map { false })
            .map { (isStart: $0, startDate: periodDateSubject.value.startDate, endDate: periodDateSubject.value.endDate) }
            .eraseToAnyPublisher()
        
        input.didSelecetedPeriod
            .sink(receiveValue: periodDateSubject.send)
            .store(in: &cancellables)
        
        let periodAttributedStrings = periodDateSubject
            .map(dateToAttributedString)
            .eraseToAnyPublisher()
        
        input.didSelectedTime
            .sink(receiveValue: timeSubject.send)
            .store(in: &cancellables)
        
        let timeAttributedString = timeSubject
            .compactMap { $0 }
            .map { AttributedString($0) }
            .eraseToAnyPublisher()
        
        input.didSelectPhoto
            .flatMap(useCase.downSampleImageData)
            .sink(receiveValue: photoSubject.send)
            .store(in: &cancellables)
        
        let selectedImage = photoSubject
            .eraseToAnyPublisher()
        
        input.didChangeStudyNameTextField
            .compactMap { $0 }
            .sink(receiveValue: studyNameSubject.send)
            .store(in: &cancellables)
        
        let isBiggerThanTwenty = checkFieldLength(studyNameSubject, maxLength: 20)
        
        let titleCount = studyNameSubject
            .map { ($0, 20) }
            .flatMap(useCase.setTextFieldCount)
            .eraseToAnyPublisher()
        
        input.didChangeStudyExplainTextView
            .compactMap { $0 }
            .sink(receiveValue: explainSubject.send)
            .store(in: &cancellables)
        
        let isBiggerThanHundredExplain = checkFieldLength(explainSubject, maxLength: 100)
        
        let explainCount = explainSubject
            .map { ($0, 100) }
            .flatMap(useCase.setTextFieldCount)
            .eraseToAnyPublisher()
        
        let explainBeginText = input.didBeginExplainEditting
            .map { "스터디를 소개해주세요." }
            .flatMap(useCase.setTextViewText)
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        input.didChangeStudyRuleTextView
            .compactMap { $0 }
            .sink(receiveValue: ruleSubject.send)
            .store(in: &cancellables)
        
        let isBiggerThanHundredRule = ruleSubject
            .map { ($0, 100) }
            .flatMap(useCase.checkTextFieldLonggestThanMax)
            .eraseToAnyPublisher()
        
        let ruleCount = ruleSubject
            .map { ($0, 100) }
            .flatMap(useCase.setTextFieldCount)
            .eraseToAnyPublisher()
        
        let ruleBeginText = input.didBeginStudyRuleEditting
            .map { "스터디를 소개해주세요." }
            .flatMap(useCase.setTextViewText)
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        input.didSelectedRepeatDays
            .sink(receiveValue: repeatTypeSubject.send)
            .store(in: &cancellables)
        
        
        input.didTapRandomColorButton
            .map { randomButtonColorSubject.value }
            .sink(receiveValue: randomBackgroundColorSubject.send)
            .store(in: &cancellables)
        
        input.didTapRandomColorButton
            .map {
                var newRandomColor = StumeetColor.random.color
                while newRandomColor == randomBackgroundColorSubject.value {
                    newRandomColor = StumeetColor.random.color
                }
                return newRandomColor
            }
            .sink(receiveValue: randomButtonColorSubject.send)
            .store(in: &cancellables)
        
        
        let snackBarText = input.didTapCompleteButton
            .map {CreateStudyGroup(
                image: photoSubject.value?.jpegData(compressionQuality: 0.1),
                name: studyNameSubject.value,
                field: fieldSubject.value,
                tags: addedTagsSubject.value,
                explain: explainSubject.value,
                region: regionSubject.value,
                startDate: self.dateToYYYYMMDD(date: periodDateSubject.value.startDate),
                endDate: self.dateToYYYYMMDD(date: periodDateSubject.value.endDate),
                time: self.convertTo24HourFormat(timeString: timeSubject.value),
                repetType: repeatTypeSubject.value,
                repetDays: repeatTypeSubject.value?.days,
                rule: ruleSubject.value)}
            .flatMap(useCase.getIsShowSnackBar)
            .map { $0 ? "! 필수 내용 작성이 완료되지 않았어요." : "" }
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
            showPHPickerVC: input.didTapAddImageButton,
            selectedImage: selectedImage,
            isBiggerThanTwenty: isBiggerThanTwenty,
            isBiggerThanHundredExplain: isBiggerThanHundredExplain,
            titleCount: titleCount,
            explainCount: explainCount,
            explainBeginText: explainBeginText,
            isBiggerThanHundredRule: isBiggerThanHundredRule,
            ruleCount: ruleCount,
            ruleBeginText: ruleBeginText,
            goToSelectStudyRepeatVC: input.didTapRepeatButton,
            selectedRepeatDays: input.didSelectedRepeatDays.eraseToAnyPublisher(),
            snackBarText: snackBarText,
            imageViewBackgroundColor: randomBackgroundColorSubject.eraseToAnyPublisher(),
            randomButtonColor: randomButtonColorSubject.eraseToAnyPublisher(),
            dismiss: input.didTapXButton
        )
    }
}

extension CreateStudyGroupViewModel {
    
    // MARK: - Function
    
    private func dateToAttributedString(start: Date, end: Date?) -> (start: AttributedString, end: AttributedString?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy,M.d"
        
        let startAttributedString = AttributedString(dateFormatter.string(from: start))
        guard let end = end else { return (startAttributedString, nil) }
        let endAttributedString = AttributedString(dateFormatter.string(from: end))
        
        return (startAttributedString, endAttributedString)
        
    }
    
    private func dateToYYYYMMDD(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        return dateString
        
    }
    
    func checkFieldLength(_ subject: CurrentValueSubject<String, Never>, maxLength: Int) -> AnyPublisher<Bool, Never> {
        return subject
            .map { ($0, maxLength) }
            .flatMap(useCase.checkTextFieldLonggestThanMax)
            .eraseToAnyPublisher()
    }
    
    func convertTo24HourFormat(timeString: String?) -> String? {
        guard let timeString = timeString else { return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        
        guard let date = dateFormatter.date(from: timeString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let formattedTime = dateFormatter.string(from: date)
        
        return formattedTime
    }
}
