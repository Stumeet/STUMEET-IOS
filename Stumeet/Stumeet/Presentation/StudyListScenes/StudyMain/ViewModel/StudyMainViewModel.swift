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
        let reachedCollectionViewBottom: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyGroupDetailHeaderDataSource: AnyPublisher<StudyMainViewHeaderItem?, Never>
        let studyGroupDetailInfoDataSource: AnyPublisher<StudyMainViewDetailInfoItem?, Never>
        let studyActivityDataSource: AnyPublisher<[StudyMainViewActivityItem]?, Never>
    }
    
    // MARK: - Properties
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount - 1}
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var useCase: StudyGroupMainUseCase
    private var studyMainViewHeaderItemSubject = CurrentValueSubject<StudyMainViewHeaderItem?, Never>(nil)
    private var studyMainViewDetailInfoItemSubject = CurrentValueSubject<StudyMainViewDetailInfoItem?, Never>(nil)
    private var studyMainViewActivityItemSubject = CurrentValueSubject<[StudyMainViewActivityItem]?, Never>(nil)
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
        let studyActivityDataSource = studyMainViewActivityItemSubject.eraseToAnyPublisher()
        
        input.loadStudyGroupDetailData
            .map { self.studyID }
            .flatMap(useCase.getStudyGroupDetail)
            .sink(receiveValue: updateStudyGroupDetailView(receiveValue:))
            .store(in: &cancellables)
        
        
        input.loadStudyGroupDetailData
            .handleEvents(receiveOutput: resetPages )
            .map { (self.nextPage, self.studyID) }
            .flatMap(useCase.getActivityItems(page:studyId:))
            .sink(receiveValue: updateStudyGroupActivityView(receiveValue:))
            .store(in: &cancellables)
        
        input.reachedCollectionViewBottom
            .filter { self.hasMorePages }
            .map { (self.nextPage, self.studyID) }
            .flatMap(useCase.getActivityItems(page:studyId:))
            .sink(receiveValue: updateStudyGroupActivityView(receiveValue:))
            .store(in: &cancellables)
    
        return Output(
            studyGroupDetailHeaderDataSource: studyGroupDetailHeaderDataSource,
            studyGroupDetailInfoDataSource: studyGroupDetailInfoDataSource,
            studyActivityDataSource: studyActivityDataSource
        )
    }
    
    private func appendPage(_ pageInfo: PageInfo) {
        currentPage = pageInfo.currentPage
        totalPageCount = pageInfo.totalPages
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        studyMainViewActivityItemSubject.send(nil)
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
    
    private func updateStudyGroupActivityView(receiveValue: ActivityPage) {
        appendPage(receiveValue.pageInfo)
        
        let newItems = receiveValue.activitys.map {
            StudyMainViewActivityItem(
                id: $0.id,
                type: $0.tag ?? .freedom,
                title: $0.title,
                content: $0.content ?? "",
                startTiem: $0.startTiem,
                endTime: $0.endTime,
                place: $0.place,
                authorProfileImage: $0.image,
                authorName: $0.name ?? "익명",
                createdAt: $0.day ?? "",
                cellType: .normal
            )
        }
            
        var resultData = studyMainViewActivityItemSubject.value ?? []
        
        resultData.append(contentsOf: newItems)
        
        let updatedResultData = resultData.enumerated().map { index, item in
            StudyMainViewActivityItem(
                id: item.id,
                type: item.type,
                title: item.title,
                content: item.content,
                startTiem: item.startTiem,
                endTime: item.endTime,
                place: item.place,
                authorProfileImage: item.authorProfileImage,
                authorName: item.authorName,
                createdAt: item.createdAt,
                cellType: index == 0 ? .activityFirstCell : .normal
            )
        }
        studyMainViewActivityItemSubject.send(updatedResultData)
    }
}
