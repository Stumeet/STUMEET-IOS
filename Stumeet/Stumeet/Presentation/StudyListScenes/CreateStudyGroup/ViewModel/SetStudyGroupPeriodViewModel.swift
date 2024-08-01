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
        
    }
    
    // MARK: - Output
    
    struct Output {
        let calendarSectionItems: AnyPublisher<[CalendarSectionItem], Never>
        let yearMonthTitle: AnyPublisher<String, Never>
        let selectedStartDate: AnyPublisher<AttributedString?, Never>
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
        let selectedStartDateSubject = CurrentValueSubject<String, Never>(startDate)
        
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
            .map { date -> AttributedString? in
                AttributedString(date)
            }
            .eraseToAnyPublisher()
        
        return Output(
            calendarSectionItems: calendarSectionItems,
            yearMonthTitle: yearMonthTitle,
            selectedStartDate: selectedStartDate
        )
    }
    
    // MARK: - Function

    func makeComponents() -> DateComponents {
        var component = DateComponents()
        let now = Date()
        component.year = cal.component(.year, from: now)
        component.month = cal.component(.month, from: now)
        component.day = 1
        
        return component
    }
    
    func setSectionItems(dateItems: [CalendarDate]) -> [CalendarSectionItem] {
        var sectionItems: [CalendarSectionItem] = []
        sectionItems.append(contentsOf: dateItems.map { .dayCell($0) })
        sectionItems.append(contentsOf: CalendarWeek.weeks.map { .weekCell($0) })
        return sectionItems
    }
}
