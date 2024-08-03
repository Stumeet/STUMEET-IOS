//
//  StudyMainViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/16.
//

import Foundation
import Combine
import Algorithms

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
        let studyActivityNoticeDataSource: AnyPublisher<StudyMainViewActivityItem?, Never>
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
    private var studyMainViewActivityNoticeItemSubject = CurrentValueSubject<StudyMainViewActivityItem?, Never>(nil)
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
        let studyActivityNoticeDataSource = studyMainViewActivityNoticeItemSubject.eraseToAnyPublisher()
        let studyActivityDataSource = studyMainViewActivityItemSubject.eraseToAnyPublisher()
        
        input.loadStudyGroupDetailData
            .compactMap { [weak self] in self?.studyID }
            .flatMap(useCase.getStudyGroupDetail)
            .sink(receiveValue: updateHeaderAndDetailInfo(receiveValue:))
            .store(in: &cancellables)
        
        input.loadStudyGroupDetailData
            .handleEvents(receiveOutput: resetPages )
            .map { (self.nextPage, self.studyID) }
            .flatMap(useCase.getActivityItems(page:studyId:))
            .map(updateActivityPageData(receiveValue:))
            .sink(receiveValue: studyMainViewActivityItemSubject.send)
            .store(in: &cancellables)
        
        input.loadStudyGroupDetailData
            .compactMap { [weak self] in self?.studyID }
            .flatMap(useCase.getActivityNoticeItem(studyId:))
            .compactMap { [weak self] receiveValue in
                self?.convertToActivityViewItems(
                from: receiveValue,
                cellType: .notice
            ).first
            }
            .sink(receiveValue: studyMainViewActivityNoticeItemSubject.send)
            .store(in: &cancellables)
        
        input.reachedCollectionViewBottom
            .filter { [weak self] in self?.hasMorePages ?? false }
            .map { (self.nextPage, self.studyID) }
            .flatMap(useCase.getActivityItems(page:studyId:))
            .handleEvents(receiveOutput: { [weak self] in self?.appendPage($0.pageInfo) })
            .map(updateActivityPageData(receiveValue:))
            .sink(receiveValue: studyMainViewActivityItemSubject.send)
            .store(in: &cancellables)
    
        return Output(
            studyGroupDetailHeaderDataSource: studyGroupDetailHeaderDataSource,
            studyGroupDetailInfoDataSource: studyGroupDetailInfoDataSource,
            studyActivityNoticeDataSource: studyActivityNoticeDataSource,
            studyActivityDataSource: studyActivityDataSource
        )
    }
    
    // MARK: - Function
    private func appendPage(_ pageInfo: PageInfo) {
        currentPage = pageInfo.currentPage
        totalPageCount = pageInfo.totalPages
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        studyMainViewActivityItemSubject.send(nil)
    }
    
    private func convertToActivityViewItems(
        from activityPage: ActivityPage,
        cellType: StudyMainViewActivityItem.StudyMainActivityCellStyle
    ) -> [StudyMainViewActivityItem] {
        return activityPage.activitys.map {
            StudyMainViewActivityItem(
                activity: $0,
                cellType: cellType
            )
        }
    }
    
    private func updateHeaderAndDetailInfo(receiveValue: StudyGroupDetail) {
        studyMainViewHeaderItemSubject
            .send(StudyMainViewHeaderItem(studyGroupDetail: receiveValue))
        
        studyMainViewDetailInfoItemSubject
            .send(StudyMainViewDetailInfoItem(studyGroupDetail: receiveValue))
    }
     
    private func updateActivityPageData(receiveValue: ActivityPage) -> [StudyMainViewActivityItem]? {
        let newItems = convertToActivityViewItems(from: receiveValue, cellType: .normal)
        
        var updateDataSource = studyMainViewActivityItemSubject.value ?? []
        
        updateDataSource.append(contentsOf: newItems)
        
        let uniquedData = Array(updateDataSource.uniqued())
        
        return uniquedData.enumerated().map { index, item in
            var updatedItem = item
            updatedItem.cellType = index == 0 ? .activityFirstCell : .normal
            return updatedItem
        }
    }
}
