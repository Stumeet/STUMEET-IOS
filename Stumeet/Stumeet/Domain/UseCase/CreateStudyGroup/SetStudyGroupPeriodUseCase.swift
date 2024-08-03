//
//  SetStudyGroupPeriodUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 8/1/24.
//

import Combine
import Foundation

protocol SetStudyGroupPeriodUseCase {
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never>
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never>
    func setCalendarItem(cal: Calendar, components: DateComponents, selectedDate: Date?) -> AnyPublisher<CalendarData, Never>
    func setYearMonthTitle(cal: Calendar, components: DateComponents) -> AnyPublisher<String, Never>
    func setIsEnableBackMonthButton(components: DateComponents, cal: Calendar) -> AnyPublisher<Bool, Never>
    func setSelectedCalendarCell(
        indexPath: IndexPath,
        item: [CalendarDate],
        components: DateComponents,
        cal: Calendar) -> AnyPublisher<CalendarData, Never>
    func getIsEnableCompleteButton(start: Date?, end: Date?) -> AnyPublisher<Bool, Never>
}

final class DefaultSetStudyGroupPeriodUseCase: SetStudyGroupPeriodUseCase {
    
    private let repository: SetStudyGroupPeriodRepository
    
    init(repository: SetStudyGroupPeriodRepository) {
        self.repository = repository
    }
    
    func setAdjustHeight(bottomSheetHeight: CGFloat, translationY: CGFloat) -> AnyPublisher<CGFloat, Never> {
        return Just(max(0, min(536, bottomSheetHeight - translationY)))
            .eraseToAnyPublisher()
    }
    
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat) -> AnyPublisher<Bool, Never> {
        return Just((velocityY > 1500 || bottomSheetHeight < 268)).eraseToAnyPublisher()
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
            
            if let selectedDate = selectedDate, cal.isDate(selectedDate, inSameDayAs: compareDate) {
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
    
    
    func setIsEnableBackMonthButton(components: DateComponents, cal: Calendar) -> AnyPublisher<Bool, Never> {
        let currentMonth = cal.component(.month, from: Date())
        let selectedMonth = components.month
        return Just(selectedMonth != currentMonth).eraseToAnyPublisher()
    }
    
    func setSelectedCalendarCell(
        indexPath: IndexPath,
        item: [CalendarDate],
        components: DateComponents,
        cal: Calendar) -> AnyPublisher<CalendarData, Never> {
        
        let dateIndex = indexPath.item
        var components = components
        components.day = Int(item[dateIndex].date)!
        var selectedDate: Date?
        
        var updatedItems = item
        var selectedItem = updatedItems[dateIndex]
        
        selectedItem.isSelected.toggle()
        updatedItems[dateIndex] = selectedItem
        
        if selectedItem.isSelected {
            selectedDate = cal.date(from: components)
            for index in updatedItems.indices where updatedItems[index].isSelected && index != (dateIndex) {
                updatedItems[index].isSelected = false
            }
        }
        let calendarData = CalendarData(selectedDate: selectedDate, data: updatedItems)
        return Just(calendarData).eraseToAnyPublisher()
    }
    
    func getIsEnableCompleteButton(start: Date?, end: Date?) -> AnyPublisher<Bool, Never> {
        return Just(start != nil && end != nil).eraseToAnyPublisher()
    }
}

extension DefaultSetStudyGroupPeriodUseCase {
    private func makeMonthDateFormmater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }
}
