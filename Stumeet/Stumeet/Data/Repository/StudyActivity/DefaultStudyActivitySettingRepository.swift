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
    
    // TODO: - api 수정되면 이어서 작업하기
    
    func postStudyActivity(activity: CreateActivity) -> AnyPublisher<Bool, Never> {
//        let requestDTO = PostActivityRequestDTO(
//            category: activity.category.title,
//            title: activity.title,
//            content: activity.content,
//            images: activity.images,
//            isNotice: activity.isNotice,
//            startDate: activity.startDate,
//            endDate: activity.endDate,
//            location: activity.location,
//            participants: activity.participants)
        // 임시 코드
        return Just(false).eraseToAnyPublisher()
    }
    
    
}
