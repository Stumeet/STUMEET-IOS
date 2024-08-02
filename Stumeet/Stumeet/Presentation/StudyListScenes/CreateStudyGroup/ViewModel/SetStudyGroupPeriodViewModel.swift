//
//  SetStudyGroupPeriodViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 8/1/24.
//

import Combine
import Foundation

final class SetStudyGroupPeriodViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapNextMonthButton: AnyPublisher<Void, Never>
        let didTapBackMonthButton: AnyPublisher<Void, Never>
        let didSelectedCalendarCell: AnyPublisher<IndexPath, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let calendarSectionItems: AnyPublisher<[CalendarSectionItem], Never>
        let yearMonthTitle: AnyPublisher<String, Never>
        let selectedStartDate: AnyPublisher<AttributedString?, Never>
        let isEnableBackMonthButton: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: SetStudyGroupPeriodUseCase
    private let startDate: String
    private let cal: Calendar = Calendar.current
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: SetStudyGroupPeriodUseCase, startDate: String) {
        self.useCase = useCase
        self.startDate = startDate
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        let calendarDateItemSubject = CurrentValueSubject<[CalendarDate], Never>([])
        let componentsSubject = CurrentValueSubject<DateComponents, Never>(makeComponents())
        let selectedStartDateSubject = CurrentValueSubject<Date?, Never>(initDate(date: startDate))
        
        useCase.setCalendarItem(cal: cal, components: componentsSubject.value, selectedDate: nil)
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        let calendarSectionItems = calendarDateItemSubject
            .map(setSectionItems)
            .eraseToAnyPublisher()
        
        let yearMonthTitle = componentsSubject
            .map { (self.cal, $0) }
            .flatMap(useCase.setYearMonthTitle)
            .eraseToAnyPublisher()
        
        let selectedStartDate = selectedStartDateSubject
            .compactMap(dateToString)
            .map { date -> AttributedString? in
                AttributedString(date)
            }
            .eraseToAnyPublisher()
        
        input.didTapNextMonthButton
            .map { (+1, componentsSubject.value, selectedStartDateSubject.value) }
            .map(updateComponentMonth)
            .map {
                componentsSubject.send($1)
                return ($0, $1, $2)
            }
            .flatMap(useCase.setCalendarItem)
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        input.didTapBackMonthButton
            .map { (-1, componentsSubject.value, selectedStartDateSubject.value) }
            .map(updateComponentMonth)
            .map {
                componentsSubject.send($1)
                return ($0, $1, $2)
            }
            .flatMap(useCase.setCalendarItem)
            .map { $0.data }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        let isEnableBackMonthButton = componentsSubject
            .map { ($0, self.cal) }
            .flatMap(useCase.setIsEnableBackMonthButton)
            .eraseToAnyPublisher()
        
        input.didSelectedCalendarCell
            .map { ($0, calendarDateItemSubject.value, componentsSubject.value, self.cal) }
            .flatMap(useCase.setSelectedCalendarCell)
            .sink(receiveValue: { data in
                selectedStartDateSubject.send(data.selectedDate)
                calendarDateItemSubject.send(data.data)
            })
            .store(in: &cancellable)
        
        return Output(
            calendarSectionItems: calendarSectionItems,
            yearMonthTitle: yearMonthTitle,
            selectedStartDate: selectedStartDate,
            isEnableBackMonthButton: isEnableBackMonthButton
        )
    }
    
    // MARK: - Function

    private func makeComponents() -> DateComponents {
        var component = DateComponents()
        let now = Date()
        component.year = cal.component(.year, from: now)
        component.month = cal.component(.month, from: now)
        component.day = 1
        
        return component
    }
    
    private func setSectionItems(dateItems: [CalendarDate]) -> [CalendarSectionItem] {
        var sectionItems: [CalendarSectionItem] = []
        sectionItems.append(contentsOf: dateItems.map { .dayCell($0) })
        sectionItems.append(contentsOf: CalendarWeek.weeks.map { .weekCell($0) })
        return sectionItems
    }
    
    private func updateComponentMonth(increment: Int, components: DateComponents, date: Date?) -> (Calendar, DateComponents, Date?) {
        var components = components
        components.month! += increment
        return (cal, components, date)
    }
    
    private func initDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        let dateString = dateFormatter.date(from: date)
        
        return dateString
    }
    
    private func dateToString(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        return dateFormatter.string(from: date)
    }
    
}
