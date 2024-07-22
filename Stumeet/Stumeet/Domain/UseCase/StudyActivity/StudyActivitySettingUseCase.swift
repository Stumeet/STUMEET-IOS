//
//  StudyActivitySettingUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 7/5/24.
//

import Combine
import Foundation

protocol StudyActivitySettingUseCase {
    func getShowSnackBarText(category: ActivityCategory, place: String?, members: [ActivityMember] ) -> AnyPublisher<String, Never>
    func postActivity(activity: CreateActivity) -> AnyPublisher<Bool, Never>
}

final class DefaultStudyActivitySettingUseCase: StudyActivitySettingUseCase {
    
    private let repository: StudyActivitySettingRepository
    
    init(repository: StudyActivitySettingRepository) {
        self.repository = repository
    }
    
    func getShowSnackBarText(category: ActivityCategory, place: String?, members: [ActivityMember]) -> AnyPublisher<String, Never> {
        var text = ""
        switch category {
        case .homework:
            text = members.isEmpty ? "! 활동 작성이 완료되지 않았어요." : ""
        case .meeting:
            text = members.isEmpty || place == nil ? "! 활동 작성이 완료되지 않았어요." : ""
        default: break
        }
        
        return Just(text).eraseToAnyPublisher()
    }
    
    func postActivity(activity: CreateActivity) -> AnyPublisher<Bool, Never> {
        return repository.postStudyActivity(activity: activity)
    }
    
}
