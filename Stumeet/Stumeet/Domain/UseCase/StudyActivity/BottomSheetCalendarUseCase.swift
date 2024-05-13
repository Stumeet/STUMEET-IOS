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
    func setCalendarItem(cal: Calendar, components: DateComponents, selectedDate: Date?) -> AnyPublisher<CalendarData, Never>
    func setSelectedDateText(date: Date) -> AnyPublisher<AttributedString?, Never>
    func setSelectedCalendarCell(
        indexPath: IndexPath,
        item: [CalendarDate],
        components: DateComponents,
        cal: Calendar) -> AnyPublisher<CalendarData, Never>
    func setYearMonthTitle(cal: Calendar, components: DateComponents) -> AnyPublisher<String, Never>
    func setSelectedTimeButton(selectedIndex: Int, timeSelecteds: [Bool]) -> AnyPublisher<[Bool], Never>
    func setIsEnableBackMonthButton(components: DateComponents, cal: Calendar) -> AnyPublisher<Bool, Never>
    func setIsEnableCompleteButton(date: Date?, hours: [Bool], minutes: [Bool]) -> AnyPublisher<Bool, Never>
    func setCompletedDateText(date: Date, isAm: Bool, hours: [Bool], minutes: [Bool]) -> AnyPublisher<String, Never>
}

final class DefaultBottomSheetCalendarUseCase: BottomSheetCalendarUseCase {
    
    // MARK: - Properties
    
    private lazy var monthDateFormatter = makeMonthDateFormmater()
    private lazy var dayDateFormatter = makeDayDateFormatter()
    
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
        for date in 1...daysCountInMonth {
            components.day = date
            let compareDate = cal.date(from: components)!
            if cal.isDate(compareDate, inSameDayAs: now) {
                calendarDates.append(CalendarDate(date: String(date)))
            } else if compareDate < now {
                calendarDates.append(CalendarDate(date: String(date), isPast: true))
            } else if let selectedDate = selectedDate, cal.isDate(selectedDate, inSameDayAs: compareDate) {
                calendarDates.append(CalendarDate(date: String(date), isSelected: true))
            } else {
                calendarDates.append(CalendarDate(date: String(date)))
            }
        }
        let calendarData = CalendarData(selectedDate: selectedDate, data: calendarDates)
        return Just(calendarData).eraseToAnyPublisher()
    }
    
    func setSelectedDateText(date: Date) -> AnyPublisher<AttributedString?, Never> {
        let selectedDateText = dayDateFormatter.string(from: date)
        return Just(AttributedString(selectedDateText)).eraseToAnyPublisher()
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
    
    func setYearMonthTitle(cal: Calendar, components: DateComponents) -> AnyPublisher<String, Never> {
        return Just(monthDateFormatter.string(from: cal.date(from: components)!)).eraseToAnyPublisher()
    }
    
    func setSelectedTimeButton(selectedIndex: Int, timeSelecteds: [Bool]) -> AnyPublisher<[Bool], Never> {
        var updatedTimeSelecteds = timeSelecteds
        updatedTimeSelecteds[selectedIndex].toggle()
        
        if updatedTimeSelecteds[selectedIndex] {
            for index in updatedTimeSelecteds.indices where updatedTimeSelecteds[index] && index != (selectedIndex) {
                updatedTimeSelecteds[index] = false
            }
        }
        
        return Just(updatedTimeSelecteds).eraseToAnyPublisher()
    }
    
    func setIsEnableBackMonthButton(components: DateComponents, cal: Calendar) -> AnyPublisher<Bool, Never> {
        let currentMonth = cal.component(.month, from: Date())
        let selectedMonth = components.month
        return Just(selectedMonth != currentMonth).eraseToAnyPublisher()
    }
    
    func setIsEnableCompleteButton(date: Date?, hours: [Bool], minutes: [Bool]) -> AnyPublisher<Bool, Never> {
        
        guard let _ = date, hours.contains(true), minutes.contains(true) else {
            return Just(false).eraseToAnyPublisher()
        }
        return Just(true).eraseToAnyPublisher()
    }
    
    func setCompletedDateText(date: Date, isAm: Bool, hours: [Bool], minutes: [Bool]) -> AnyPublisher<String, Never> {
        var date = makeCompletedDateFormatter().string(from: date)
        let ampm = isAm ? "오전" : "오후"
        let hour = hours
            .firstIndex(where: { $0 })
            .map { String(format: "%02d", $0 + 1) }
        let minute = minutes
            .firstIndex(where: { $0 })
            .map { String(format: "%02d", $0 * 5)}
        
        let result = "\(date) \(ampm) \(hour!):\(minute!)"
        return Just(result).eraseToAnyPublisher()
    }
}

extension DefaultBottomSheetCalendarUseCase {
    
    func makeMonthDateFormmater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }
    
    func makeDayDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. M. d E요일"
        return dateFormatter
    }
    
    func makeCompletedDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. M. d(E)"
        return dateFormatter
    }

    func makeComponents(cal: Calendar) -> DateComponents {
        var component = DateComponents()
        let now = Date()
        component.year = cal.component(.year, from: now)
        component.month = cal.component(.month, from: now)
        component.day = 1
        
        return component
    }
}
