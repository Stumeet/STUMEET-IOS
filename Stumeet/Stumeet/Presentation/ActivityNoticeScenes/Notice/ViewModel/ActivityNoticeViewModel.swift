//
//  ActivityNoticeViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import Foundation
import Combine
import Algorithms

final class ActivityNoticeViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadData: AnyPublisher<Void, Never>
        let reachedTableViewBottom: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    struct Output {
        let activityNoticeDataSource: AnyPublisher<[StudyMainViewActivityItem], Never>
    }
    
    // MARK: - Properties
    private var studyID: Int
    private var isNextPageLoading: Bool = false
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount}
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var canLoadMorePages: Bool { hasMorePages && !isNextPageLoading }
    
    private var fetchLatestNoticeUseCase: FetchLatestNoticeUseCase
    private var fetchNoticesUseCase: FetchNoticesUseCase
    
    private var currentNoticeItemSubject = CurrentValueSubject<StudyMainViewActivityItem?, Never>(nil)
    private var pastNoticesItemSubject = CurrentValueSubject<[StudyMainViewActivityItem]?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchLatestNoticeUseCase: FetchLatestNoticeUseCase,
        fetchNoticesUseCase: FetchNoticesUseCase,
        studyID: Int
    ) {
        self.fetchLatestNoticeUseCase = fetchLatestNoticeUseCase
        self.fetchNoticesUseCase = fetchNoticesUseCase
        self.studyID = studyID
        
    }
    
    func transform(input: Input) -> Output {
        let activityNoticeDataSource = Publishers
            .CombineLatest(
                currentNoticeItemSubject,
                pastNoticesItemSubject
            )
            .map(combineNoticeItems(currentItem:pastItems:))
            .eraseToAnyPublisher()
        
        input.loadData
            .handleEvents(receiveOutput: resetPages )
            .map { (self.currentPage, self.studyID) }
            .flatMap(fetchNoticesUseCase.execute(page:studyID:))
            .map(updateActivityPageData(receiveValue:))
            .sink(receiveValue: pastNoticesItemSubject.send)
            .store(in: &cancellables)
        
        input.loadData
            .compactMap { [weak self] in self?.studyID }
            .flatMap(fetchLatestNoticeUseCase.execute(studyID:))
            .compactMap { [weak self] receiveValue in
                self?.convertToActivityViewItems(
                from: receiveValue,
                cellType: .notice
            ).first
            }
            .sink(receiveValue: currentNoticeItemSubject.send)
            .store(in: &cancellables)
        
        input.reachedTableViewBottom
            .filter { [weak self] in self?.canLoadMorePages ?? false }
            .handleEvents(receiveOutput: { [weak self] in self?.isNextPageLoading = true })
            .map { (self.nextPage, self.studyID) }
            .flatMap(fetchNoticesUseCase.execute(page:studyID:))
            .handleEvents(receiveOutput: { [weak self] in self?.appendPage($0.pageInfo) })
            .map(updateActivityPageData(receiveValue:))
            .handleEvents(receiveOutput: { [weak self] _ in self?.isNextPageLoading = false })
            .sink(receiveValue: pastNoticesItemSubject.send)
            .store(in: &cancellables)
    
        return Output(
            activityNoticeDataSource: activityNoticeDataSource
        )
    }
    
    // MARK: - Function
    private func combineNoticeItems(
        currentItem: StudyMainViewActivityItem?,
        pastItems: [StudyMainViewActivityItem]?
    ) -> [StudyMainViewActivityItem] {
        var totalList = [StudyMainViewActivityItem]()
        if let notice = currentItem {
            totalList.append(notice)
        }
        if let items = pastItems {
            totalList.append(contentsOf: items)
        }
        return totalList
    }
    
    private func appendPage(_ pageInfo: PageInfo) {
        currentPage = pageInfo.currentPage
        totalPageCount = pageInfo.totalPages
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pastNoticesItemSubject.send(nil)
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
    
    private func updateActivityPageData(receiveValue: ActivityPage) -> [StudyMainViewActivityItem]? {
        let newItems = convertToActivityViewItems(from: receiveValue, cellType: .normal)
        
        var updateDataSource = pastNoticesItemSubject.value ?? []
        
        updateDataSource.append(contentsOf: newItems)
        
        let uniquedData = Array(updateDataSource.uniqued())
        
        return uniquedData.enumerated().map { index, item in
            var updatedItem = item
            updatedItem.cellType = index == 0 ? .activityFirstCell : .normal
            return updatedItem
        }
    }
}
