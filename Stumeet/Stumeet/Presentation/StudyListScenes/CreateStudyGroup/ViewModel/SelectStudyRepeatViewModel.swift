//
//  SelectStudyRepeatViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 8/10/24.
//

import Combine
import Foundation

final class SelectStudyRepeatViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapDailyButton: AnyPublisher<Void, Never>
        let didTapWeeklyButton: AnyPublisher<Void, Never>
        let didTapMonthlyButton: AnyPublisher<Void, Never>
        let didSelectedMontlhyDay: AnyPublisher<IndexPath, Never>
        let didSelectedWeeklyDay: AnyPublisher<Int, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedRepeatType: AnyPublisher<StudyRepeatType, Never>
        let monthlyDays: AnyPublisher<[SelectStudyRepeatSectionItem], Never>
        let selectedWeeklyDays: AnyPublisher<[Bool], Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: SelectStudyRepeatUseCase
    
    // MARK: - Init
    
    init(useCase: SelectStudyRepeatUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let monthlyDaysSubject = CurrentValueSubject<[CalendarDate], Never>([])
        let weeklyDaysSubject = CurrentValueSubject<[Bool], Never>([Bool](repeating: false, count: 7))
        let selectedRepeatTypeSubject = CurrentValueSubject<StudyRepeatType?, Never>(nil)
        
        input.didTapMonthlyButton
            .map { monthlyDaysSubject.value }
            .flatMap(useCase.getMonthlyDays)
            .sink(receiveValue: monthlyDaysSubject.send)
            .store(in: &cancellables)
        
        input.didSelectedMontlhyDay
            .map { ($0, monthlyDaysSubject.value) }
            .flatMap(useCase.getSelectedMonthlyDays)
            .sink(receiveValue: monthlyDaysSubject.send)
            .store(in: &cancellables)
        
        input.didSelectedWeeklyDay
            .map { ($0, weeklyDaysSubject.value) }
            .flatMap(useCase.getIsSelectedsWeeklyDay)
            .sink(receiveValue: weeklyDaysSubject.send)
            .store(in: &cancellables)

        Publishers.Merge3(
            input.didTapDailyButton.map { StudyRepeatType.dailiy },
            input.didTapWeeklyButton.map { StudyRepeatType.weekly },
            input.didTapMonthlyButton.map { StudyRepeatType.monthly }
        )
        .sink(receiveValue: selectedRepeatTypeSubject.send)
        .store(in: &cancellables)
        
        let selectedRepeatType = selectedRepeatTypeSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let monthlyDays = monthlyDaysSubject
            .filter { !$0.isEmpty }
            .map { $0.map { SelectStudyRepeatSectionItem.monthlyCell($0) } }
            .eraseToAnyPublisher()
        
        let isEnableCompleteButton = Publishers.CombineLatest3(
            selectedRepeatTypeSubject,
            weeklyDaysSubject,
            monthlyDaysSubject
        )
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        

        return Output(
            selectedRepeatType: selectedRepeatType,
            monthlyDays: monthlyDays,
            selectedWeeklyDays: weeklyDaysSubject.eraseToAnyPublisher(),
            isEnableCompleteButton: isEnableCompleteButton
        )
    }
}
