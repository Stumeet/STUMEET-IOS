//
//  SelectStudyTimeUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import Combine
import Foundation

protocol SelectStudyTimeUseCase {
    func getSelectedTimeButton(selectedIndex: Int, timeSelecteds: [Bool]) -> AnyPublisher<[Bool], Never>
    func initIsAm() -> AnyPublisher<Bool, Never>
    func initHourSelecteds() -> AnyPublisher<[Bool], Never>
    func initMinuteSelecteds() -> AnyPublisher<[Bool], Never>
    func getIsEnableCompleteButton(hours: [Bool], minutes: [Bool]) -> AnyPublisher<Bool, Never>
    func getCompletedTimeText(isAm: Bool, hours: [Bool], minutes: [Bool]) -> AnyPublisher<String, Never>
}


final class DefaultSelectStudyTimeUseCase: SelectStudyTimeUseCase {
    func getSelectedTimeButton(selectedIndex: Int, timeSelecteds: [Bool]) -> AnyPublisher<[Bool], Never> {
        var updatedTimeSelecteds = timeSelecteds
        updatedTimeSelecteds[selectedIndex].toggle()
        
        if updatedTimeSelecteds[selectedIndex] {
            for index in updatedTimeSelecteds.indices where updatedTimeSelecteds[index] && index != (selectedIndex) {
                updatedTimeSelecteds[index] = false
            }
        }
        
        return Just(updatedTimeSelecteds).eraseToAnyPublisher()
    }
    
    func initHourSelecteds() -> AnyPublisher<[Bool], Never> {
        let timeSelecteds = Array(repeating: false, count: 12)
        return Just(timeSelecteds).eraseToAnyPublisher()
    }

    func initMinuteSelecteds() -> AnyPublisher<[Bool], Never> {
        let timeSelecteds = Array(repeating: false, count: 12)
        return Just(timeSelecteds).eraseToAnyPublisher()
    }
    
    func initIsAm() -> AnyPublisher<Bool, Never> {
        let now = Date()
        let calendar = Calendar.current
        
        let isAm = calendar.component(.hour, from: now) < 12
        
        return Just(isAm).eraseToAnyPublisher()
    }
    
    func getIsEnableCompleteButton(hours: [Bool], minutes: [Bool]) -> AnyPublisher<Bool, Never> {
        
        return Just(hours.contains(true) && minutes.contains(true)).eraseToAnyPublisher()
    }
    
    func getCompletedTimeText(isAm: Bool, hours: [Bool], minutes: [Bool]) -> AnyPublisher<String, Never> {
        let ampm = isAm ? "오전" : "오후"
        let hour = hours
            .firstIndex(where: { $0 })
            .map { String(format: "%02d", $0 + 1) }
        let minute = minutes
            .firstIndex(where: { $0 })
            .map { String(format: "%02d", $0 * 5)}
        
        let result = "\(ampm) \(hour!):\(minute!)"
        return Just(result).eraseToAnyPublisher()
    }
}
