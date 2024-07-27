//
//  StudyMainViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Foundation
import Combine

final class StudyMainViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadStudyGroupDetailData: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyGroupDetailHeaderDataSource: AnyPublisher<StudyMainViewHeaderItem?, Never>
        let studyGroupDetailInfoDataSource: AnyPublisher<StudyMainViewDetailInfoItem?, Never>
    }
    
    // MARK: - Properties
    private var useCase: StudyGroupMainUseCase
    private var studyMainViewHeaderItemSubject = CurrentValueSubject<StudyMainViewHeaderItem?, Never>(nil)
    private var studyMainViewDetailInfoItemSubject = CurrentValueSubject<StudyMainViewDetailInfoItem?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    private var studyID: Int
    
    // MARK: - Init
    init(
        useCase: StudyGroupMainUseCase,
        studyID: Int
    ) {
        self.useCase = useCase
        self.studyID = studyID
    }
    
    func transform(input: Input) -> Output {
        let studyGroupDetailHeaderDataSource = studyMainViewHeaderItemSubject.eraseToAnyPublisher()
        let studyGroupDetailInfoDataSource = studyMainViewDetailInfoItemSubject.eraseToAnyPublisher()
        
        input.loadStudyGroupDetailData
            .map { self.studyID }
            .flatMap(useCase.getStudyGroupDetail)
            .sink(receiveValue: updateStudyGroupDetailView(receiveValue:))
            .store(in: &cancellables)
    
        return Output(
            studyGroupDetailHeaderDataSource: studyGroupDetailHeaderDataSource,
            studyGroupDetailInfoDataSource: studyGroupDetailInfoDataSource
        )
    }
    
    private func updateStudyGroupDetailView(receiveValue: StudyGroupDetail) {
        studyMainViewHeaderItemSubject
            .send(
                StudyMainViewHeaderItem(
                    title: receiveValue.name,
                    thumbnailImageUrl: receiveValue.image
                )
            )
        
        studyMainViewDetailInfoItemSubject
            .send(
                StudyMainViewDetailInfoItem(
                    intro: receiveValue.intro,
                    rule: receiveValue.rule,
                    region: receiveValue.region,
                    tags: receiveValue.tags.map { "#\($0)" },
                    startDate: receiveValue.startDate,
                    endDate: receiveValue.endDate,
                    meetingTime: receiveValue.meetingTime,
                    meetingRepetitionType: .init(rawValue: receiveValue.meetingRepetitionType),
                    meetingRepetitionDates: receiveValue.meetingRepetitionDates
                )
            )
    }

}
