//
//  DefaultStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 2/26/24.
//

import Combine
import Foundation

final class DefaultStudyActivityRepository: StudyActivityRepository {
    
    private var items: [StudyActivitySectionItem] = []
    private var activityItemsSubject = CurrentValueSubject<[StudyActivitySectionItem], Never>([])
    
    func fetchActivityItems(type: StudyActivitySectionItem) -> AnyPublisher<[StudyActivitySectionItem], Never> {
        
        switch type {
            
        case .all:
            items = Activity.allData.map { StudyActivitySectionItem.all($0) }
            activityItemsSubject.send(items)
            return activityItemsSubject.eraseToAnyPublisher()
            
        case .group:
            items = Activity.groupData.map { StudyActivitySectionItem.group($0) }
            activityItemsSubject.send(items)
            return activityItemsSubject.eraseToAnyPublisher()
            
        case .task:
            items = Activity.taskData.map { StudyActivitySectionItem.task($0) }
            activityItemsSubject.send(items)
            return activityItemsSubject.eraseToAnyPublisher()
        }
    }
}
