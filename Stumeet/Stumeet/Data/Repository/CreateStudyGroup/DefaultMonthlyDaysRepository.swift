//
//  DefaultMonthlyDaysRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import Combine
import Foundation

final class DefaultMonthlyDaysRepository: MonthlyDaysRepository {
    func getMonthlyDays() -> AnyPublisher<[CalendarDate], Never> {
        var days = [CalendarDate]()
        for day in 1...31 {
            days.append(CalendarDate(date: String(day)))
        }
        days.append(CalendarDate(date: "마지막 날"))
        
        return Just(days).eraseToAnyPublisher()
    }
}
