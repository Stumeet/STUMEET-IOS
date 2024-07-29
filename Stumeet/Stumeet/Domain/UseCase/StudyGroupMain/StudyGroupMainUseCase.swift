//
//  StudyGroupMainUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Combine

protocol StudyGroupMainUseCase {
    func getStudyGroupDetail(studyId: Int) -> AnyPublisher<StudyGroupDetail, Never>
    func getActivityItems (
        page: Int,
        studyId: Int
    ) -> AnyPublisher<ActivityPage, Never>
}

final class DefaultStudyGroupMainUseCase: StudyGroupMainUseCase {
    
    private let studyMainRepository: StudyGroupMainRepository
    private let studyActivityRepository: StudyActivityRepository
    
    init(studyMainRepository: StudyGroupMainRepository,
         studyActivityRepository: StudyActivityRepository
    ) {
        self.studyMainRepository = studyMainRepository
        self.studyActivityRepository = studyActivityRepository
    }
    
    func getStudyGroupDetail(studyId: Int) -> AnyPublisher<StudyGroupDetail, Never> {
        return studyMainRepository.fetchDetailStudyGroupInfo(studyId: studyId)
            .catch { error -> AnyPublisher<StudyGroupDetail, Never> in
                fatalError("error: \(error)")
            }
            .eraseToAnyPublisher()
    }

    func getActivityItems (
        page: Int,
        studyId: Int
    ) -> AnyPublisher<ActivityPage, Never> {
        return studyActivityRepository.fetchActivityDetailItems(
            size: 10,
            page: page,
            isNotice: nil,
            studyId: studyId,
            category: nil
        )
        .catch { error -> AnyPublisher<ActivityPage, Never> in
            fatalError("error: \(error)")
        }
        .eraseToAnyPublisher()
    }
}
