//
//  BottomSheetCalendarUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/31/24.
//

import Combine
import Foundation

protocol BottomSheetCalendarUseCase {
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never>
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never>
    func setCalendarItem(cal: Calendar, dateFormatter: DateFormatter, components: DateComponents) -> AnyPublisher<CalendarDay, Never>
    func setSelectedDay(dateFormatter: DateFormatter) -> AnyPublisher<AttributedString?, Never>
}

final class DefualtBottomSheetCalendarUseCase: BottomSheetCalendarUseCase {
    
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never> {
        return Just(max(0, min(536, bottomSheetHeight - translationY)))
            .eraseToAnyPublisher()
    }
    
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never> {
        return Just((velocityY > 1500 || bottomSheetHeight < 268)).eraseToAnyPublisher()
    }
    
    func setCalendarItem(cal: Calendar, dateFormatter: DateFormatter, components: DateComponents) -> AnyPublisher<CalendarDay, Never> {
        
        var calendarDay: CalendarDay = CalendarDay(day: "", month: String(components.month!), days: [])
        
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        let daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        let adjustedFirstWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1
        
        // 첫 주의 빈 칸 계산 (1 = 월요일이므로 0 빈 칸, 7 = 일요일이므로 6 빈 칸)
        let emptyDays = adjustedFirstWeekday - 1
        
        calendarDay.day = dateFormatter.string(from: firstDayOfMonth!)
        for i in 0..<emptyDays {
                calendarDay.days.append(String(i * -1))
            }

        // 실제 날짜 채우기
        for day in 1...daysCountInMonth {
            calendarDay.days.append(String(day))
        }
        
        return Just(calendarDay).eraseToAnyPublisher()
    }
    
    func setSelectedDay(dateFormatter: DateFormatter) -> AnyPublisher<AttributedString?, Never> {
        let selectedDay = dateFormatter.string(from: Date())
        return Just(AttributedString(selectedDay)).eraseToAnyPublisher()
    }
}
