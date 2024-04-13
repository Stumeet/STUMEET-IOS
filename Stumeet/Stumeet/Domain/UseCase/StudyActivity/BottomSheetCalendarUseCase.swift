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
    func setCalendarItem() -> AnyPublisher<CalendarDay, Never>
}

final class DefualtBottomSheetCalendarUseCase: BottomSheetCalendarUseCase {
    
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never> {
        return Just(max(0, min(536, bottomSheetHeight - translationY)))
            .eraseToAnyPublisher()
    }
    
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never> {
        return Just((velocityY > 1500 || bottomSheetHeight < 268)).eraseToAnyPublisher()
    }
    
    func setCalendarItem() -> AnyPublisher<CalendarDay, Never> {
        let cal = Calendar.current
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년M월"
            return dateFormatter
        }()
        
        var components: DateComponents {
            var component = DateComponents()
            let now = Date()
            component.year = cal.component(.year, from: now)
            component.month = cal.component(.month, from: now)
            component.day = 1
            
            return component
        }
        
        var calendarDay: CalendarDay = CalendarDay(day: "", days: [])
        
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        let daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        let weekdayAdding = 2 - firstWeekday
        
        calendarDay.day = dateFormatter.string(from: firstDayOfMonth!)
        
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                calendarDay.days.append("")
            } else {
                calendarDay.days.append(String(day))
            }
        }
        return Just(calendarDay).eraseToAnyPublisher()
    }
}
