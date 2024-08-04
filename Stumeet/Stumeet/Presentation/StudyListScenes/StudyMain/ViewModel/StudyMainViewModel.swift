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
        let didTapToggleActivityButton: AnyPublisher<Void, Never>
        let didTapMenuOpenButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    struct Output {
        let studyGroupDetailHeaderDataSource: AnyPublisher<StudyMainViewHeaderItem?, Never>
        let studyGroupDetailInfoDataSource: AnyPublisher<StudyMainViewDetailInfoItem?, Never>
        let studyActivityDataSource: AnyPublisher<[StudyMainViewActivityItem], Never>
        let switchedViewToActivity: AnyPublisher<Bool, Never>
        let presentToSideMenuVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    var isActivity: Bool = true
    private var isNextPageLoading: Bool = false
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount}
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var canLoadMorePages: Bool { hasMorePages && !isNextPageLoading }
    private var useCase: StudyGroupMainUseCase
    private var studyMainViewHeaderItemSubject = CurrentValueSubject<StudyMainViewHeaderItem?, Never>(nil)
    private var studyMainViewDetailInfoItemSubject = CurrentValueSubject<StudyMainViewDetailInfoItem?, Never>(nil)
    private var studyMainViewActivityNoticeItemSubject = CurrentValueSubject<StudyMainViewActivityItem?, Never>(nil)
    private var studyMainViewActivityItemSubject = CurrentValueSubject<[StudyMainViewActivityItem]?, Never>(nil)
    private var studyID: Int
    private var cancellables = Set<AnyCancellable>()
    
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
        
        let studyActivityDataSource = Publishers
            .CombineLatest(
                studyMainViewActivityNoticeItemSubject,
                studyMainViewActivityItemSubject
            )
            .map(combineActivityItems(noticeItem:activityItems:))
            .eraseToAnyPublisher()
        
        let switchedViewToActivity = input.didTapToggleActivityButton
            .map(toggleActivityState)
            .eraseToAnyPublisher()
        
        let presentToSideMenuVC = input.didTapMenuOpenButton.eraseToAnyPublisher()
        
        input.loadStudyGroupDetailData
            .compactMap { [weak self] in self?.studyID }
            .flatMap(useCase.getStudyGroupDetail)
            .sink(receiveValue: updateHeaderAndDetailInfo(receiveValue:))
            .store(in: &cancellables)
        
        input.loadStudyGroupDetailData
            .handleEvents(receiveOutput: resetPages )
            .map { (self.currentPage, self.studyID) }
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
            .filter { [weak self] in self?.canLoadMorePages ?? false }
            .handleEvents(receiveOutput: { [weak self] in self?.isNextPageLoading = true })
            .map { (self.nextPage, self.studyID) }
            .flatMap(useCase.getActivityItems(page:studyId:))
            .handleEvents(receiveOutput: { [weak self] in self?.appendPage($0.pageInfo) })
            .map(updateActivityPageData(receiveValue:))
            .handleEvents(receiveOutput: { [weak self] _ in self?.isNextPageLoading = false })
            .sink(receiveValue: studyMainViewActivityItemSubject.send)
            .store(in: &cancellables)
    
        return Output(
            studyGroupDetailHeaderDataSource: studyGroupDetailHeaderDataSource,
            studyGroupDetailInfoDataSource: studyGroupDetailInfoDataSource,
            studyActivityDataSource: studyActivityDataSource,
            switchedViewToActivity: switchedViewToActivity,
            presentToSideMenuVC: presentToSideMenuVC
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
    
    private func toggleActivityState() -> Bool {
        isActivity.toggle()
        return isActivity
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
    
    func combineActivityItems(
        noticeItem: StudyMainViewActivityItem?,
        activityItems: [StudyMainViewActivityItem]?
    ) -> [StudyMainViewActivityItem] {
        var totalList = [StudyMainViewActivityItem]()
        if let notice = noticeItem {
            totalList.append(notice)
        }
        if let items = activityItems {
            totalList.append(contentsOf: items)
        }
        return totalList
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
