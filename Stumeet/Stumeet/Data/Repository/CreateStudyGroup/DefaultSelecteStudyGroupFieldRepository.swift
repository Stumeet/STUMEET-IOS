//
//  DefaultSelecteStudyGroupFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

final class DefaultSelecteStudyGroupFieldRepository: SelectStudyGroupFieldRepository {
    
    func getFieldItems() -> AnyPublisher<[StudyField], Never> {
        let fields = [
            StudyField(name: "어학", isSelected: false),
            StudyField(name: "취업", isSelected: false),
            StudyField(name: "자격증", isSelected: false),
            StudyField(name: "고시/공무원", isSelected: false),
            StudyField(name: "취미/교양", isSelected: false),
            StudyField(name: "프로그래밍", isSelected: false),
            StudyField(name: "재테크/경제", isSelected: false),
            StudyField(name: "수능", isSelected: false),
            StudyField(name: "독서", isSelected: false),
            StudyField(name: "자율", isSelected: false)
        ]
        
        return Just(fields).eraseToAnyPublisher()
    }
}
