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
    }
    
    // MARK: - Output
    
    struct Output {
        let isBeginEditing: AnyPublisher<Bool, Never>
        let isEnableNextButton: AnyPublisher<Bool, Never>
        let selectedCategory: AnyPublisher<AttributedString?, Never>
        let maxLengthText: AnyPublisher<String, Never>
        let dismiss: AnyPublisher<Void, Never>
        let isHiddenCategoryItems: AnyPublisher<Bool, Never>
        let presentToPickerVC: AnyPublisher<Void, Never>
        let photosItem: AnyPublisher<[UIImage], Never>
    }
    
    // MARK: - Properties
    
    private let useCase: CreateActivityUseCase
    let currentCategorySubject = CurrentValueSubject<ActivityCategory, Never>(.freedom)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: CreateActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let contentSubject = CurrentValueSubject<String, Never>("")
        let titleSubject = CurrentValueSubject<String, Never>("")
        
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
        
        let didTapNextButton = input.didTapNextButton
        
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

        let selectedCategory = currentCategorySubject
            .map { category -> AttributedString? in
                return AttributedString(category.title)
            }
            .eraseToAnyPublisher()
        
        input.didTapCategoryItem
            .sink(receiveValue: currentCategorySubject.send)
            .store(in: &cancellables)
        
        let presentToPickerVC = input.didTapImageButton.eraseToAnyPublisher()
        
        let photosItem = input.didSelectedPhotos.eraseToAnyPublisher()
        
        let dismiss = input.didTapXButton
            .eraseToAnyPublisher()
        
        return Output(
            isBeginEditing: isBeginEditing,
            isEnableNextButton: isEnableNextButton,
            selectedCategory: selectedCategory,
            maxLengthText: maxLengthText,
            dismiss: dismiss,
            isHiddenCategoryItems: isHiddenCategoryItems,
            presentToPickerVC: presentToPickerVC,
            photosItem: photosItem
        )
    }
}
