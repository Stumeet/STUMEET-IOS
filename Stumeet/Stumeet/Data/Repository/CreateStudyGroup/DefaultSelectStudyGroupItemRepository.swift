//
//  DefaultSelecteStudyGroupFieldRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import Foundation

final class DefaultSelectStudyGroupItemRepository: SelectStudyGroupItemRepository {
    
    func getFieldItems() -> AnyPublisher<[SelectStudyItem], Never> {
        let fields = [
            SelectStudyItem(name: "어학", isSelected: false),
            SelectStudyItem(name: "취업", isSelected: false),
            SelectStudyItem(name: "자격증", isSelected: false),
            SelectStudyItem(name: "고시/공무원", isSelected: false),
            SelectStudyItem(name: "취미/교양", isSelected: false),
            SelectStudyItem(name: "프로그래밍", isSelected: false),
            SelectStudyItem(name: "재테크/경제", isSelected: false),
            SelectStudyItem(name: "수능", isSelected: false),
            SelectStudyItem(name: "독서", isSelected: false),
            SelectStudyItem(name: "자율", isSelected: false)
        ]
        
        return Just(fields).eraseToAnyPublisher()
    }
    
    func getRegionItems() -> AnyPublisher<[SelectStudyItem], Never> {
        let regions = [
            SelectStudyItem(name: "서울", isSelected: false),
            SelectStudyItem(name: "인천/경기", isSelected: false),
            SelectStudyItem(name: "전북", isSelected: false),
            SelectStudyItem(name: "전남", isSelected: false),
            SelectStudyItem(name: "강원", isSelected: false),
            SelectStudyItem(name: "경북", isSelected: false),
            SelectStudyItem(name: "경남", isSelected: false),
            SelectStudyItem(name: "충북", isSelected: false),
            SelectStudyItem(name: "충남", isSelected: false),
            SelectStudyItem(name: "제주", isSelected: false),
            SelectStudyItem(name: "해외", isSelected: false)
        ]
        
        return Just(regions).eraseToAnyPublisher()
    }
}
