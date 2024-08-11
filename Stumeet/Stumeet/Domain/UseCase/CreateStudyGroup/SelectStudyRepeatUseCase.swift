//
//  SelectStudyRepeatUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import Combine
import Foundation

protocol SelectStudyRepeatUseCase {
    func getMonthlyDays(currentDays: [CalendarDate]) -> AnyPublisher<[CalendarDate], Never>
}

final class DefaultSelectStudyRepeatUseCase: SelectStudyRepeatUseCase {

    private let repository: MonthlyDaysRepository
    
    init(repository: MonthlyDaysRepository) {
        self.repository = repository
    }
    
    func getMonthlyDays(currentDays: [CalendarDate]) -> AnyPublisher<[CalendarDate], Never> {
        if currentDays.isEmpty {
            return repository.getMonthlyDays()
        } else {
            return Just(currentDays).eraseToAnyPublisher()
        }
    }
}
