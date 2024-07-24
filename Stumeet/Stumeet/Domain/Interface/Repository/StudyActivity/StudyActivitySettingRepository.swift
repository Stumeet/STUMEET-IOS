//
//  StudyActivitySettingRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 7/5/24.
//

import Combine
import Foundation

protocol StudyActivitySettingRepository {
    func postStudyActivity(activity: CreateActivity) -> AnyPublisher<Bool, Never>
}
