//
//  SelectStudyTimeUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import Combine
import Foundation

protocol SelectStudyTimeUseCase {
    func setSelectedTimeButton(selectedIndex: Int, timeSelecteds: [Bool]) -> AnyPublisher<[Bool], Never>
    func initIsAm() -> AnyPublisher<Bool, Never>
    func initHourSelecteds() -> AnyPublisher<[Bool], Never>
    func initMinuteSelecteds() -> AnyPublisher<[Bool], Never>
}


final class DefaultSelectStudyTimeUseCase: SelectStudyTimeUseCase {
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
    
    func
}

extension DefaultSelectStudyTimeUseCase {
}
