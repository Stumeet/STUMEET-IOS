//
//  DefaultDetailStudyActivityRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

final class DefaultDetailStudyActivityRepository: DetailStudyActivityRepository {
    func fetchDetailActivityItems(studyID: Int, activityID: Int) -> AnyPublisher<[DetailStudyActivitySectionItem], Never> {
        return Empty().eraseToAnyPublisher()
    }
}

final class MockDetailStudyActivityRepository: DetailStudyActivityRepository {
    
    // MARK: - Mock
    
    func fetchDetailActivityItems(studyID: Int, activityID: Int) -> AnyPublisher<[DetailStudyActivitySectionItem], Never> {
        let top = DetailStudyActivityTop(
            dayLeft: "18일 남음",
            status: "미제출",
            profileImageURL: "",
            name: "홍길동",
            date: "2024.01.01 23:58",
            title: "캠스터디 교재 1장 2번까지 풀이",
            content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고, 풀이 정리 후 정답, 오답 공유 후 질의 응답합니다!")
        
        let photo1 = DetailStudyActivityPhoto(imageURL: "1")
        let photo2 = DetailStudyActivityPhoto(imageURL: "2")
        let photo3 = DetailStudyActivityPhoto(imageURL: "3")
        let photo4 = DetailStudyActivityPhoto(imageURL: "4")
        
        let bottom = DetailStudyActivityBottom(
            memberImageURL: [""],
            startDate: "2024. 1. 29(월) 오전 9:00",
            endDate: "2024. 1. 29(월) 오전 9:00",
            place: "서울여자대학교 학생누리관 7층")
        
        let items: [DetailStudyActivitySectionItem] = [
            .topCell(top),
            .photoCell(photo1),
            .photoCell(photo2),
            .photoCell(photo3),
            .photoCell(photo4),
            .bottomCell(bottom)
        ]
        
        return Just(items).eraseToAnyPublisher()
    }
}
