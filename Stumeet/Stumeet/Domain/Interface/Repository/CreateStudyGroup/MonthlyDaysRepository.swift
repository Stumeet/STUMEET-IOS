//
//  MonthlyDaysRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import Combine
import Foundation

protocol MonthlyDaysRepository {
    func getMonthlyDays() -> AnyPublisher<[CalendarDate], Never>
}
