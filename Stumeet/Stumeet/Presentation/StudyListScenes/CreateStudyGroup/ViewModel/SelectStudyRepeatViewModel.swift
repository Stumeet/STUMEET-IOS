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
    }
    
    // MARK: - Output
    
    struct Output {
        let dailyViewHeight: AnyPublisher<CGFloat, Never>
        let weeklyViewHeight: AnyPublisher<CGFloat, Never>
        let monthlyViewHeight: AnyPublisher<CGFloat, Never>
        let monthlyDays: AnyPublisher<[SelectStudyRepeatSectionItem], Never>
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
        
        input.didTapMonthlyButton
            .map { monthlyDaysSubject.value }
            .flatMap(useCase.getMonthlyDays)
            .sink(receiveValue: monthlyDaysSubject.send)
            .store(in: &cancellables)
        
        let monthlyDays = monthlyDaysSubject
            .filter { !$0.isEmpty }
            .map { $0.map { SelectStudyRepeatSectionItem.monthlyCell($0) } }
            .eraseToAnyPublisher()
        
        let dailyViewHeight = input.didTapDailyButton
            .map { CGFloat(245) }
            .eraseToAnyPublisher()
        
        let weeklyViewHeight = input.didTapWeeklyButton
            .map { CGFloat(301) }
            .eraseToAnyPublisher()
        
        let monthlyViewHeight = input.didTapMonthlyButton
            .map { CGFloat(518) }
            .eraseToAnyPublisher()
        
        
        
        return Output(
            dailyViewHeight: dailyViewHeight,
            weeklyViewHeight: weeklyViewHeight,
            monthlyViewHeight: monthlyViewHeight,
            monthlyDays: monthlyDays
        )
    }
}
