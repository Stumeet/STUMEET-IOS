//
//  DefaultStudyActivitySettingRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 7/5/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class DefaultStudyActivitySettingRepository: StudyActivitySettingRepository {
    
    private let provider: MoyaProvider<ActivityService>
    
    init(provider: MoyaProvider<ActivityService>) {
        self.provider = provider
    }
    
    // FIXME: studyID 임시 설정
    
    func postStudyActivity(activity: CreateActivity) -> AnyPublisher<Bool, Never> {
        
        let requestDTO = PostActivityRequestDTO(
            category: activity.category.rawValue,
            title: activity.title,
            content: activity.content,
            images: [],
            isNotice: activity.isNotice,
            startDate: activity.startDate?.convertToISOFormat(),
            endDate: activity.endDate?.convertToISOFormat(),
            location: activity.location,
            link: activity.link,
            participants: activity.participants
        )
        
        return provider.requestPublisher(.postActivity(requestDTO))
            .map { _ in true }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    
}
