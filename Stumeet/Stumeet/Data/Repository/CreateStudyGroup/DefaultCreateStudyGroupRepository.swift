//
//  DefaultCreateStudyGroupRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 8/26/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

final class DefaultCreateStudyGroupRepository: CreateStudyGroupRepository {
    
    private let provider: MoyaProvider<StudyService>
    
    init(provider: MoyaProvider<StudyService>) {
        self.provider = provider
    }
    
    
    func postCreateStudyGroup(data: CreateStudyGroup) -> AnyPublisher<Bool, Never> {
        
        let requestDTO = CreateStudyGroupRequestDTO(
            image: data.image,
            studyField: data.field,
            name: data.name,
            intro: data.explain,
            region: data.region,
            rule: data.rule,
            startDate: data.startDate,
            endDate: data.endDate,
            meetingTime: data.time!,
            meetingRepetitionType: data.repetType!.request,
            meetingRepetitionDates: data.repetDays!,
            studyTags: data.tags
        )
        
        return provider.requestPublisher(.createStudyGroup(requestDTO))
            .map(ResponseDTO.self)
            .map { _ in true }
            .catch { error -> AnyPublisher<Bool, Never> in
                print("Error occurred: \(error)")
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
