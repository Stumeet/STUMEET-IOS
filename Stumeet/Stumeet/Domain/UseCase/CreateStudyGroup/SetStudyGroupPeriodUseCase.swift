//
//  SetStudyGroupPeriodUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 8/1/24.
//

import Combine
import Foundation

protocol SetStudyGroupPeriodUseCase {
    func setCalendarItem(cal: Calendar, components: DateComponents, selectedDate: Date?) -> AnyPublisher<CalendarData, Never>
    func setYearMonthTitle(cal: Calendar, components: DateComponents) -> AnyPublisher<String, Never> 
}

final class DefaultSetStudyGroupPeriodUseCase: SetStudyGroupPeriodUseCase {
    
    private let repository: SetStudyGroupPeriodRepository
    
    init(repository: SetStudyGroupPeriodRepository) {
        self.repository = repository
    }
    
    func setCalendarItem(cal: Calendar, components: DateComponents, selectedDate: Date?) -> AnyPublisher<CalendarData, Never> {
        
        var calendarDates: [CalendarDate] = []
        
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        let daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        let adjustedFirstWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1
        
        let emptyDays = adjustedFirstWeekday - 1
        
        for idx in 0..<emptyDays {
            let date = String(idx * -1)
            calendarDates.append(CalendarDate(date: date))
        }
        
        let now = Date()
        var components = components
        let actualSelectedDate = selectedDate ?? now // selectedDate가 nil이면 현재 날짜를 사용
        
        for date in 1...daysCountInMonth {
            components.day = date
            let compareDate = cal.date(from: components)!
            
            if cal.isDate(actualSelectedDate, inSameDayAs: compareDate) {
                calendarDates.append(CalendarDate(date: String(date), isSelected: true))
            } else if cal.isDate(compareDate, inSameDayAs: now) {
                calendarDates.append(CalendarDate(date: String(date)))
            } else if compareDate < now {
                calendarDates.append(CalendarDate(date: String(date), isPast: true))
            } else {
                calendarDates.append(CalendarDate(date: String(date)))
            }
        }
        
        let calendarData = CalendarData(selectedDate: selectedDate, data: calendarDates)
        return Just(calendarData).eraseToAnyPublisher()
    }
    
    func setYearMonthTitle(cal: Calendar, components: DateComponents) -> AnyPublisher<String, Never> {
        return Just(makeMonthDateFormmater().string(from: cal.date(from: components)!)).eraseToAnyPublisher()
    }
}

extension DefaultSetStudyGroupPeriodUseCase {
    private func makeMonthDateFormmater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }
}
