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
    func getSelectedMonthlyDays(indexPath: IndexPath, currentDays: [CalendarDate]) -> AnyPublisher<[CalendarDate], Never>
    func getIsSelectedsWeeklyDay(index: Int, currentWeeklys: [Bool]) -> AnyPublisher<[Bool], Never>
    func getIsEnableCompleteButton(selectedType: StudyRepeatType?, weeklys: [Bool], monthlys: [CalendarDate]) -> AnyPublisher<Bool, Never>
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
    
    func getSelectedMonthlyDays(indexPath: IndexPath, currentDays: [CalendarDate]) -> AnyPublisher<[CalendarDate], Never> {
        var updatedDays = currentDays
        
        updatedDays[indexPath.item].isSelected.toggle()
        return Just(updatedDays).eraseToAnyPublisher()
    }
    
    func getIsSelectedsWeeklyDay(index: Int, currentWeeklys: [Bool]) -> AnyPublisher<[Bool], Never> {
        var updatedWeeklys = currentWeeklys
        updatedWeeklys[index].toggle()
        
        return Just(updatedWeeklys).eraseToAnyPublisher()
    }
    
    func getIsEnableCompleteButton(selectedType: StudyRepeatType?, weeklys: [Bool], monthlys: [CalendarDate]) -> AnyPublisher<Bool, Never> {
        var isEnable = false
        switch selectedType {
        case .dailiy:
            isEnable = true
        case .weekly:
            isEnable = weeklys.filter { $0 }.count > 0
        case .monthly:
            isEnable = monthlys.filter { $0.isSelected }.count > 0
        case .none:
            isEnable = false
        }
        
        return Just(isEnable).eraseToAnyPublisher()
    }
}
