//
//  CreateActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import UIKit
import Combine
import Foundation

final class CreateActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didChangeTitle: AnyPublisher<String?, Never>
        let didChangeContent: AnyPublisher<String?, Never>
        let didBeginEditing: AnyPublisher<Void, Never>
        let didTapCategoryButton: AnyPublisher<Void, Never>
        let didTapCategoryItem: AnyPublisher<ActivityCategory, Never>
        let didChangedNoticeSwitch: AnyPublisher<Bool, Never>
        let didTapXButton: AnyPublisher<Void, Never>
        let didTapNextButton: AnyPublisher<Void, Never>
        let didTapImageButton: AnyPublisher<Void, Never>
        let didSelectedPhotos: AnyPublisher<[UIImage], Never>
        let didTapCellXButton: AnyPublisher<UIImage, Never>
        let didTapLinkButton: AnyPublisher<Void, Never>
        let didChangedLink: AnyPublisher<String?, Never>
        let didTapPopUpStayButton: AnyPublisher<Void, Never>
        let didTapPopUpExitButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isBeginEditing: AnyPublisher<Bool, Never>
        let isEnableNextButton: AnyPublisher<Bool, Never>
        let selectedCategory: AnyPublisher<ActivityCategory, Never>
        let maxLengthText: AnyPublisher<String, Never>
        let exitPopUp: AnyPublisher<PopUp?, Never>
        let isHiddenCategoryItems: AnyPublisher<Bool, Never>
        let presentToPickerVC: AnyPublisher<Void, Never>
        let photosItem: AnyPublisher<[UIImage], Never>
        let presentToLinkPopUpVC: AnyPublisher<Void, Never>
        let isEmptyPhotoItem: AnyPublisher<Bool, Never>
        let linkText: AnyPublisher<String, Never>
        let dismiss: AnyPublisher<Void, Never>
        let createActivityData: AnyPublisher<CreateActivity, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: CreateActivityUseCase
    private var cancellables = Set<AnyCancellable>()
    private let initialCategory: ActivityCategory
    
    // MARK: - Init
    
    init(useCase: CreateActivityUseCase, category: ActivityCategory) {
        self.useCase = useCase
        self.initialCategory = category
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let contentSubject = CurrentValueSubject<String, Never>("")
        let titleSubject = CurrentValueSubject<String, Never>("")
        let isNoticeSubject = CurrentValueSubject<Bool, Never>(false)
        let selectedCategorySubject = CurrentValueSubject<ActivityCategory, Never>(initialCategory)
        let linkSubject = CurrentValueSubject<String?, Never>(nil)
        let photoSubject = CurrentValueSubject<[UIImage], Never>([])
        let exitPopUpSubject = PassthroughSubject<PopUp?, Never>()
        
        input.didChangeContent
            .compactMap { $0 }
            .sink(receiveValue: contentSubject.send)
            .store(in: &cancellables)
        
        input.didChangeTitle
            .compactMap { $0 }
            .sink(receiveValue: titleSubject.send)
            .store(in: &cancellables)
        
        let maxLengthText = contentSubject
            .compactMap { $0 }
            .flatMap(useCase.setMaxLengthText)
            .eraseToAnyPublisher()
        
        let isBeginEditing = input.didBeginEditing
            .map { _ in true }
            .eraseToAnyPublisher()
        
        let isHiddenCategoryItems = Publishers.Merge(
            input.didTapCategoryButton.map { false },
            input.didTapCategoryItem.map { _ in true })
            .scan(true) { isHidden, newValue in
                newValue ? true : !isHidden
            }
            .eraseToAnyPublisher()

        let selectedCategory = selectedCategorySubject.eraseToAnyPublisher()
        
        input.didTapCategoryItem
            .sink(receiveValue: selectedCategorySubject.send)
            .store(in: &cancellables)
        
        input.didSelectedPhotos
            .sink(receiveValue: photoSubject.send)
            .store(in: &cancellables)
        
        input.didTapCellXButton
            .map { ($0, photoSubject.value) }
            .flatMap(useCase.deletePhoto)
            .sink(receiveValue: photoSubject.send)
            .store(in: &cancellables)
        
        input.didChangedNoticeSwitch
            .sink(receiveValue: isNoticeSubject.send)
            .store(in: &cancellables)
        
        input.didChangedLink
            .sink(receiveValue: linkSubject.send)
            .store(in: &cancellables)
        
        let isEnableNextButton = input.didTapNextButton
            .map { (titleSubject.value, contentSubject.value) }
            .flatMap(useCase.setIsEnableNextButton)
            .eraseToAnyPublisher()
        
        let createActivityData = input.didTapNextButton
            .map {
                CreateActivity(
                    category: selectedCategorySubject.value,
                    title: titleSubject.value,
                    content: contentSubject.value,
                    images: photoSubject.value.map { $0.jpegData(compressionQuality: 1.0)! },
                    isNotice: isNoticeSubject.value,
                    startDate: nil,
                    endDate: nil,
                    location: nil,
                    link: linkSubject.value,
                    participants: []
                )
            }
            .eraseToAnyPublisher()

        let isEmptyPhotoItem = photoSubject
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
        
        input.didTapXButton
            .map {
                PopUp(
                    title: "작성중인 활동은 저장되지 않아요.",
                    subTitle: "활동 생성을 그만두시겠어요?",
                    leftButtonTitle: "머무르기",
                    rightButtonTitle: "나가기")
            }
            .sink(receiveValue: exitPopUpSubject.send)
            .store(in: &cancellables)
        
        input.didTapPopUpStayButton
            .map { nil }
            .sink(receiveValue: exitPopUpSubject.send)
            .store(in: &cancellables)
        
        
        let dismiss = input.didTapPopUpExitButton
        
        return Output(
            isBeginEditing: isBeginEditing,
            isEnableNextButton: isEnableNextButton,
            selectedCategory: selectedCategory,
            maxLengthText: maxLengthText,
            exitPopUp: exitPopUpSubject.eraseToAnyPublisher(),
            isHiddenCategoryItems: isHiddenCategoryItems,
            presentToPickerVC: input.didTapImageButton.eraseToAnyPublisher(),
            photosItem: photoSubject.eraseToAnyPublisher(),
            presentToLinkPopUpVC: input.didTapLinkButton.eraseToAnyPublisher(),
            isEmptyPhotoItem: isEmptyPhotoItem,
            linkText: linkSubject.compactMap { $0 }.eraseToAnyPublisher(),
            dismiss: dismiss,
            createActivityData: createActivityData
        )
    }
}
