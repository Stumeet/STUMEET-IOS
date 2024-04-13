//
//  DefaultStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

final class DefaultStudyActivityRepository: StudyActivityRepository {
    
    private var items: [StudyActivityItem] = []
    private var activityItemsSubject = CurrentValueSubject<[StudyActivityItem], Never>([])
    
    func fetchActivityItems(type: StudyActivityItem) -> AnyPublisher<[StudyActivityItem], Never> {
        
        switch type {
            
        case .all:
            items = Activity.allData.map { StudyActivityItem.all($0) }
            activityItemsSubject.send(items)
            return activityItemsSubject.eraseToAnyPublisher()
            
        case .group:
            items = Activity.groupData.map { StudyActivityItem.group($0) }
            activityItemsSubject.send(items)
            return activityItemsSubject.eraseToAnyPublisher()
            
        case .task:
            items = Activity.taskData.map { StudyActivityItem.task($0) }
            activityItemsSubject.send(items)
            return activityItemsSubject.eraseToAnyPublisher()
        }
    }
}
