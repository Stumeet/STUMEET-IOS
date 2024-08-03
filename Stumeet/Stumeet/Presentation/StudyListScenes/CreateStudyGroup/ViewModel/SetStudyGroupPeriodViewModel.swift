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
        let didTapStartDateButton: AnyPublisher<Void, Never>
        let didTapEndDateButton: AnyPublisher<Void, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let calendarSectionItems: AnyPublisher<[CalendarSectionItem], Never>
        let yearMonthTitle: AnyPublisher<String, Never>
        let selectedStartDate: AnyPublisher<AttributedString?, Never>
        let selectedEndDate: AnyPublisher<AttributedString?, Never>
        let isEnableBackMonthButton: AnyPublisher<Bool, Never>
        let isSelectedStartDateButton: AnyPublisher<Bool, Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let selectedPeriod: AnyPublisher<(startDate: Date, endDate: Date), Never>
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
        let startDateItemSubject = CurrentValueSubject<[CalendarDate], Never>([])
        let endDateItemSubject = CurrentValueSubject<[CalendarDate], Never>([])
        
        let componentsSubject = CurrentValueSubject<DateComponents?, Never>(nil)
        let startComponentsSubject = CurrentValueSubject<DateComponents, Never>(makeComponents())
        let endComponentsSubject = CurrentValueSubject<DateComponents, Never>(makeComponents())
        
        let selectedDateSubject = CurrentValueSubject<Date?, Never>(nil)
        let selectedStartDateSubject = CurrentValueSubject<Date?, Never>(initDate(isStart: true))
        let selectedEndDateSubject = CurrentValueSubject<Date?, Never>(initDate(isStart: false))
        
        let isStartDateSelected = CurrentValueSubject<Bool, Never>(true)
        
        isStartDateSelected
            .combineLatest(startDateItemSubject, endDateItemSubject)
            .map { isStartSelected, startItem, endItem in
                isStartSelected ? startItem : endItem
            }
            .sink(receiveValue: calendarDateItemSubject.send)
            .store(in: &cancellable)
        
        isStartDateSelected
            .combineLatest(startComponentsSubject, endComponentsSubject)
            .map { isStartSelected, startComponents, endComponents in
                isStartSelected ? startComponents : endComponents
            }
            .sink(receiveValue: componentsSubject.send)
            .store(in: &cancellable)
        
        isStartDateSelected
            .combineLatest(selectedStartDateSubject, selectedEndDateSubject)
            .map { isStartSelected, selectedStartDate, selectedEndDate in
                isStartSelected ? selectedStartDate : selectedEndDate
            }
            .sink(receiveValue: selectedDateSubject.send)
            .store(in: &cancellable)
        
        input.didTapStartDateButton
            .map { true }
            .merge(with: input.didTapEndDateButton.map { false })
            .removeDuplicates()
            .sink(receiveValue: isStartDateSelected.send)
            .store(in: &cancellable)
        
        isStartDateSelected
            .map { $0 ? selectedStartDateSubject.value : selectedEndDateSubject.value }
            .combineLatest(isStartDateSelected.map { $0 ? startComponentsSubject.value : endComponentsSubject.value })
            .map { (date, components) in (self.cal, components, date) }
            .flatMap(useCase.setCalendarItem)
            .map { ($0.data, isStartDateSelected.value, startDateItemSubject, endDateItemSubject)}
            .sink(receiveValue: sendToSubject)
            .store(in: &cancellable)
        
        let calendarSectionItems = calendarDateItemSubject
            .map(setSectionItems)
            .eraseToAnyPublisher()
        
        let yearMonthTitle = componentsSubject
            .compactMap { $0 }
            .map { (self.cal, $0) }
            .flatMap(useCase.setYearMonthTitle)
            .eraseToAnyPublisher()
        
        let selectedStartDate = selectedStartDateSubject
            .compactMap(dateToString)
            .map { date -> AttributedString? in
                AttributedString(date)
            }
            .eraseToAnyPublisher()
        
        let selectedEndDate = selectedEndDateSubject
            .compactMap(dateToString)
            .map { date -> AttributedString? in
                AttributedString(date)
            }
            .eraseToAnyPublisher()
        
        input.didTapNextMonthButton
            .compactMap { componentsSubject.value }
            .map { (1, $0, selectedDateSubject.value) }
            .map(updateComponentMonth)
            .handleEvents(receiveOutput: { [weak self] _, components, _ in
                self?.sendToSubject(components, isStartDateSelected.value, startComponentsSubject, endComponentsSubject)
            })
            .flatMap(useCase.setCalendarItem)
            .map { ($0.data, isStartDateSelected.value, startDateItemSubject, endDateItemSubject)}
            .sink(receiveValue: sendToSubject)
            .store(in: &cancellable)
        
        input.didTapBackMonthButton
            .compactMap { componentsSubject.value }
            .map { (-1, $0, selectedDateSubject.value) }
            .map(updateComponentMonth)
            .handleEvents(receiveOutput: { [weak self] _, components, _ in
                self?.sendToSubject(components, isStartDateSelected.value, startComponentsSubject, endComponentsSubject)
            })
            .flatMap(useCase.setCalendarItem)
            .map { ($0.data, isStartDateSelected.value, startDateItemSubject, endDateItemSubject)}
            .sink(receiveValue: sendToSubject)
            .store(in: &cancellable)
        
        let isEnableBackMonthButton = componentsSubject
            .compactMap { $0 }
            .map { ($0, self.cal) }
            .flatMap(useCase.setIsEnableBackMonthButton)
            .eraseToAnyPublisher()
        
        input.didSelectedCalendarCell
            .map { ($0, calendarDateItemSubject.value, componentsSubject.value!, self.cal) }
            .flatMap(useCase.setSelectedCalendarCell)
            .sink(receiveValue: { [weak self] data in
                self?.sendToSubject(data.selectedDate, isStartDateSelected.value, selectedStartDateSubject, selectedEndDateSubject)
                self?.sendToSubject(data.data, isStartDateSelected.value, startDateItemSubject, endDateItemSubject)
            })
            .store(in: &cancellable)
        
        let isEnableCompleteButton = Publishers.CombineLatest(selectedStartDateSubject, selectedEndDateSubject)
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let selectedPeriod = input.didTapCompleteButton
            .map { (startDate: selectedStartDateSubject.value!, endDate: selectedEndDateSubject.value!) }
            .eraseToAnyPublisher()
        
        return Output(
            calendarSectionItems: calendarSectionItems,
            yearMonthTitle: yearMonthTitle,
            selectedStartDate: selectedStartDate,
            selectedEndDate: selectedEndDate,
            isEnableBackMonthButton: isEnableBackMonthButton,
            isSelectedStartDateButton: isStartDateSelected.eraseToAnyPublisher(),
            isEnableCompleteButton: isEnableCompleteButton,
            selectedPeriod: selectedPeriod
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
    
    private func initDate(isStart: Bool) -> Date? {
        guard let date = isStart ? startDate : nil else { return nil}
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
    
    private func sendToSubject<T>(
        _ value: T,
        _ isStartDateSelected: Bool,
        _ startSubject: CurrentValueSubject<T, Never>,
        _ endSubject: CurrentValueSubject<T, Never>
    ) {
        if isStartDateSelected {
            startSubject.send(value)
        } else {
            endSubject.send(value)
        }
    }

}
