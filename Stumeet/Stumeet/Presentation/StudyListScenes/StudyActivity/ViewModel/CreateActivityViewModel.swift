//
//  CreateActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

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
    }
    
    // MARK: - Output
    
    struct Output {
        let isBeginEditing: AnyPublisher<Bool, Never>
        let isEnableNextButton: AnyPublisher<Bool, Never>
        let showCategoryStackView: AnyPublisher<Void, Never>
        let selectedCategory: AnyPublisher<ActivityCategory, Never>
        let isShowMaxLengthContentAlert: AnyPublisher<Bool, Never>
        let dismiss: AnyPublisher<Void, Never>
        let navigateToActivitySettingVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: ActivityCreateUseCase
    let currentCategorySubject = CurrentValueSubject<ActivityCategory, Never>(.freedom)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: ActivityCreateUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let content = input.didChangeContent
            .compactMap { $0 }
        
        let isShowAlert = content
            .flatMap(useCase.setIsShowMaxLengthAlert)
            .eraseToAnyPublisher()
        
        let title = input.didChangeTitle
            .compactMap { $0 }

        let isEnableNextButton = Publishers.CombineLatest(content, title)
            .flatMap(useCase.setEnableNextButton)
            .eraseToAnyPublisher()
        
        let isBeginEditing = input.didBeginEditing
            .map { _ in true }
            .eraseToAnyPublisher()
        
        let showCategoryStackView = input.didTapCategoryButton
            .eraseToAnyPublisher()

        let selectedCategory = currentCategorySubject.eraseToAnyPublisher()
        
        input.didTapCategoryItem
            .sink(receiveValue: currentCategorySubject.send)
            .store(in: &cancellables)
        
        let dismiss = input.didTapXButton
            .eraseToAnyPublisher()
        
        let navigateToActivitySettingVC = input.didTapNextButton.eraseToAnyPublisher()
        
        return Output(
            isBeginEditing: isBeginEditing,
            isEnableNextButton: isEnableNextButton,
            showCategoryStackView: showCategoryStackView,
            selectedCategory: selectedCategory,
            isShowMaxLengthContentAlert: isShowAlert,
            dismiss: dismiss,
            navigateToActivitySettingVC: navigateToActivitySettingVC
        )
    }
}
