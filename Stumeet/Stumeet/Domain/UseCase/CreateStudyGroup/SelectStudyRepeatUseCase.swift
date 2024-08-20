//
//  SelectStudyRepeatUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import Combine
import Foundation

protocol SelectStudyRepeatUseCase {
    func setAdjustHeight(bottomSheetHeight: CGFloat, heightByType: CGFloat?, translationY: CGFloat) -> AnyPublisher<CGFloat, Never>
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat, heightByType: CGFloat?) -> AnyPublisher<(Bool, CGFloat), Never>
    func getMonthlyDays(currentDays: [CalendarDate]) -> AnyPublisher<[CalendarDate], Never>
    func getSelectedMonthlyDays(indexPath: IndexPath, currentDays: [CalendarDate]) -> AnyPublisher<[CalendarDate], Never>
    func getIsSelectedsWeeklyDay(index: Int, currentWeeklys: [Bool]) -> AnyPublisher<[Bool], Never>
    func getIsEnableCompleteButton(selectedType: StudyRepeatType?, weeklys: [Bool], monthlys: [CalendarDate]) -> AnyPublisher<Bool, Never>
    func getCompleteDays(selectedType: StudyRepeatType?, weeklys: [Bool], monthlys: [CalendarDate]) -> AnyPublisher<StudyRepeatType, Never>
}

final class DefaultSelectStudyRepeatUseCase: SelectStudyRepeatUseCase {

    private let repository: MonthlyDaysRepository
    
    init(repository: MonthlyDaysRepository) {
        self.repository = repository
    }
    
    func setAdjustHeight(bottomSheetHeight: CGFloat, heightByType: CGFloat?, translationY: CGFloat) -> AnyPublisher<CGFloat, Never> {
        return Just(max(0, min(heightByType ?? 245, bottomSheetHeight - translationY)))
            .eraseToAnyPublisher()
    }
    
    func setIsRestoreBottomSheetView(velocityY: CGFloat, bottomSheetHeight: CGFloat, heightByType: CGFloat?) -> AnyPublisher<(Bool, CGFloat), Never> {
        return Just((velocityY > 1500 || bottomSheetHeight < heightByType ?? 245 / 2, heightByType ?? 245)).eraseToAnyPublisher()
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
    
    func getCompleteDays(selectedType: StudyRepeatType?, weeklys: [Bool], monthlys: [CalendarDate]) -> AnyPublisher<StudyRepeatType, Never> {
        var type: StudyRepeatType!
        switch selectedType {
        case .dailiy:
            type = .dailiy
        case .weekly:
            let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
            let days = weeklys.enumerated().compactMap { index, isSelected in
                isSelected ? weekdays[index] : nil
            }
            type = .weekly(days)
        case .monthly:
            let days = monthlys.filter { $0.isSelected }.map { $0.date }
            type = .monthly(days)
        case .none:
            break
        }
        
        return Just(type).eraseToAnyPublisher()
    }
}
