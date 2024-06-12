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
        let didTapXButton: AnyPublisher<Void, Never>
        let didTapNextButton: AnyPublisher<Void, Never>
        let didTapImageButton: AnyPublisher<Void, Never>
        let didSelectedPhotos: AnyPublisher<[UIImage], Never>
        let didTapCellXButton: AnyPublisher<UIImage, Never>
        let didTapLinkButton: AnyPublisher<Void, Never>
        let didChangedLink: AnyPublisher<String, Never>
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
    }
    
    // MARK: - Properties
    
    private let useCase: CreateActivityUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: CreateActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let contentSubject = CurrentValueSubject<String, Never>("")
        let titleSubject = CurrentValueSubject<String, Never>("")
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
        
        let isEnableNextButton = input.didTapNextButton
            .map { (contentSubject.value, titleSubject.value) }
            .flatMap(useCase.setIsEnableNextButton)
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

        let selectedCategory = input.didTapCategoryItem
            .eraseToAnyPublisher()
        
        let presentToPickerVC = input.didTapImageButton.eraseToAnyPublisher()
        
        let photosItem = photoSubject.eraseToAnyPublisher()
        
        input.didSelectedPhotos
            .sink(receiveValue: photoSubject.send)
            .store(in: &cancellables)
        
        input.didTapCellXButton
            .map { ($0, photoSubject.value) }
            .flatMap(useCase.deletePhoto)
            .sink(receiveValue: photoSubject.send)
            .store(in: &cancellables)
        
        let presentToLinkPopUpVC = input.didTapLinkButton.eraseToAnyPublisher()
        
        let isEmptyPhotoItem = photoSubject
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
        
        let exitPopUp = exitPopUpSubject.eraseToAnyPublisher()
        
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
            exitPopUp: exitPopUp,
            isHiddenCategoryItems: isHiddenCategoryItems,
            presentToPickerVC: presentToPickerVC,
            photosItem: photosItem,
            presentToLinkPopUpVC: presentToLinkPopUpVC,
            isEmptyPhotoItem: isEmptyPhotoItem,
            linkText: input.didChangedLink,
            dismiss: dismiss
        )
    }
}
