//
//  FetchMonthlyActivitiesUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/27.
//

import Foundation
import Combine

protocol FetchMonthlyActivitiesUseCase {
    func execute(studyID: Int, month: Date) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultFetchMonthlyActivitiesUseCase: FetchMonthlyActivitiesUseCase {
    private let repository: StudyActivityRepository

    init(repository: StudyActivityRepository) {
        self.repository = repository
    }

    func execute(studyID: Int, month: Date) -> AnyPublisher<ActivityPage, Never> {
        // 날짜 계산
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)
        let startOfMonth = calendar.date(from: components)!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

        // 날짜 포맷터
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let fromDate = dateFormatter.string(from: startOfMonth)
        let toDate = dateFormatter.string(from: endOfMonth)
        
        return repository.fetchBriefActivityList(
            size: nil,
            page: nil,
            isNotice: false,
            studyId: studyID,
            memberId: nil,
            category: nil,
            fromDate: fromDate,
            toDate: toDate
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }
}
