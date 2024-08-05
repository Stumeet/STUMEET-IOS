//
//  SelectStudyTimeViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import Combine
import Foundation

final class SelectStudyTimeViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapHourButton: AnyPublisher<Int, Never>
        let didTapMinuteButton: AnyPublisher<Int, Never>
        let didTapAmButtonTapPublisher: AnyPublisher<Void, Never>
        let didTapPmButtonTapPublisher: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isSelectedHours: AnyPublisher<[Bool], Never>
        let isSelectedMinute: AnyPublisher<[Bool], Never>
        let isSelectedAmButton: AnyPublisher<Bool, Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: SelectStudyTimeUseCase
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Init
    
    init(useCase: SelectStudyTimeUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let isAmSubject = CurrentValueSubject<Bool, Never>(true)
        let isSelectedHoursSubject = CurrentValueSubject<[Bool], Never>([])
        let isSelectedMinuteSubject = CurrentValueSubject<[Bool], Never>([])
        
        
        let isSelectedHours = isSelectedHoursSubject.eraseToAnyPublisher()
        let isSelectedMinutes = isSelectedMinuteSubject.eraseToAnyPublisher()
        let isSelectedAmButton = isAmSubject.eraseToAnyPublisher()
        
        useCase.initHourSelecteds()
            .sink(receiveValue: isSelectedHoursSubject.send)
            .store(in: &cancellables)
        
        useCase.initMinuteSelecteds()
            .sink(receiveValue: isSelectedMinuteSubject.send)
            .store(in: &cancellables)
        
        useCase.initIsAm()
            .sink(receiveValue: isAmSubject.send)
            .store(in: &cancellables)
        
        input.didTapHourButton
            .map { ($0, isSelectedHoursSubject.value) }
            .flatMap(useCase.getSelectedTimeButton)
            .sink(receiveValue: isSelectedHoursSubject.send)
            .store(in: &cancellables)
        
        input.didTapMinuteButton
            .map { ($0, isSelectedMinuteSubject.value) }
            .flatMap(useCase.getSelectedTimeButton)
            .sink(receiveValue: isSelectedMinuteSubject.send)
            .store(in: &cancellables)
        
        Publishers.Merge(
            input.didTapAmButtonTapPublisher.map { _ in true },
            input.didTapPmButtonTapPublisher.map { _ in false })
        .sink(receiveValue: isAmSubject.send)
        .store(in: &cancellables)
        
        
        let isEnableCompleteButton = Publishers.CombineLatest( isSelectedHoursSubject, isSelectedMinuteSubject)
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        
        return Output(
            isSelectedHours: isSelectedHours,
            isSelectedMinute: isSelectedMinutes,
            isSelectedAmButton: isSelectedAmButton,
            isEnableCompleteButton: isEnableCompleteButton
        )
    }
}
