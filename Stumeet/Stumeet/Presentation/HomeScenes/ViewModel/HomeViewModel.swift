//
//  HomeViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import Combine
import Foundation

final class HomeViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadData: AnyPublisher<Void, Never>
        let didTapAlarmButton: AnyPublisher<Void, Never>
        let didTapHeadderTapBarButton: AnyPublisher<HomeHeaderTapBarViewType, Never>
        let didReachTableBottom: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let presentToAlarmVC: AnyPublisher<Void, Never>
        let headerActivityDataSource: AnyPublisher<HomeHeaderActivityItem, Never>
        let activityDataSource: AnyPublisher<[HomeActivityItem], Never>
        let noticeDataSource: AnyPublisher<[HomeNoticeItem], Never>
    }
    
    // MARK: - Properties
    private var isNextPageLoading: Bool = false
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount}
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var canLoadMorePages: Bool { hasMorePages && !isNextPageLoading }
    
    private var fetchClosestActivityUseCase: FetchClosestActivityUseCase
    private var fetchClosestActivityListUseCase: FetchClosestActivityListUseCase
    private var fetchNoticesUseCase: FetchNoticesUseCase
    
    private var activityItemsSubject = CurrentValueSubject<[HomeActivityItem]?, Never>(nil)
    private var noticeItemsSubject = CurrentValueSubject<[HomeNoticeItem]?, Never>(nil)
    private var headerActivityItemSubject = CurrentValueSubject<HomeHeaderActivityItem?, Never>(nil)
    private(set) var currentTap = CurrentValueSubject<HomeHeaderTapBarViewType?, Never>(.task)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchClosestActivityUseCase: FetchClosestActivityUseCase,
        fetchClosestActivityListUseCase: FetchClosestActivityListUseCase,
        fetchNoticesUseCase: FetchNoticesUseCase
    ) {
        self.fetchClosestActivityUseCase = fetchClosestActivityUseCase
        self.fetchClosestActivityListUseCase = fetchClosestActivityListUseCase
        self.fetchNoticesUseCase = fetchNoticesUseCase
    }
    
    func transform(input: Input) -> Output {
        let headerActivityItem = headerActivityItemSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let activityItem = activityItemsSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let noticeItem = noticeItemsSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let presentToAlarmVC = input.didTapAlarmButton
            .eraseToAnyPublisher()
        
        input.loadData
            .flatMap(fetchClosestActivityUseCase.execute)
            .map(convertToHeaderActivityViewItem(from:))
            .sink(receiveValue: headerActivityItemSubject.send)
            .store(in: &cancellables)
        
        
        input.didTapHeadderTapBarButton
            .sink { [weak self] tapType in
                guard let self else { return }
                switch tapType.id {
                case 0: currentTap.send(.task)
                case 1: currentTap.send(.notice)
                default: return
                }
            }
            .store(in: &cancellables)
        
        
        input.didReachTableBottom
            .filter { [weak self] in self?.currentTap.value == .task }
            .filter { [weak self] in self?.canLoadMorePages ?? false }
            .handleEvents(receiveOutput: { [weak self] in self?.isNextPageLoading = true })
            .flatMap { [weak self] in
                guard let self else { return Empty<ActivityPage, Never>().eraseToAnyPublisher()}
                return fetchClosestActivityListUseCase.execute(page: nextPage)
            }
            .handleEvents(receiveOutput: { [weak self] in self?.appendPage($0.pageInfo) })
            .map(updateActivityPageData(receiveValue:))
            .handleEvents(receiveOutput: { [weak self] _ in self?.isNextPageLoading = false })
            .sink(receiveValue: activityItemsSubject.send)
            .store(in: &cancellables)
        
        input.didReachTableBottom
            .filter { [weak self] in self?.currentTap.value == .notice }
            .filter { [weak self] in self?.canLoadMorePages ?? false }
            .handleEvents(receiveOutput: { [weak self] in self?.isNextPageLoading = true })
            .flatMap { [weak self] in
                guard let self else { return Empty<ActivityPage, Never>().eraseToAnyPublisher()}
                return fetchNoticesUseCase.execute(page: nextPage, studyID: nil)
            }
            .handleEvents(receiveOutput: { [weak self] in self?.appendPage($0.pageInfo) })
            .map(updateNoticePageData(receiveValue:))
            .handleEvents(receiveOutput: { [weak self] _ in self?.isNextPageLoading = false })
            .sink(receiveValue: noticeItemsSubject.send)
            .store(in: &cancellables)
    
        currentTap
            .removeDuplicates()
            .filter { $0 == .task }
            .map { _ in
                self.resetPages()
                return self.currentPage
            }
            .flatMap(fetchClosestActivityListUseCase.execute(page:))
            .map(updateActivityPageData(receiveValue:))
            .sink(receiveValue: activityItemsSubject.send)
            .store(in: &cancellables)
        
        currentTap
            .removeDuplicates()
            .filter { $0 == .notice }
            .map { _ in
                self.resetPages()
                return self.currentPage
            }
            .flatMap {
                self.fetchNoticesUseCase.execute(page: $0, studyID: nil)
            }
            .map(updateNoticePageData(receiveValue:))
            .sink(receiveValue: noticeItemsSubject.send)
            .store(in: &cancellables)
     
        

        return Output(
            presentToAlarmVC: presentToAlarmVC,
            headerActivityDataSource: headerActivityItem,
            activityDataSource: activityItem,
            noticeDataSource: noticeItem
        )
    }
    
    // MARK: - Function
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        activityItemsSubject.send([])
        noticeItemsSubject.send([])
    }
    
    private func appendPage(_ pageInfo: PageInfo) {
        currentPage = pageInfo.currentPage
        totalPageCount = pageInfo.totalPages
    }
    
    private func convertToHeaderActivityViewItem(
        from activityPage: ActivityPage
    ) -> HomeHeaderActivityItem? {
        guard let item = activityPage.activitys.first else { return nil }
        return HomeHeaderActivityItem(
            activity: item
        )
    }
    
    private func convertToActivityViewItems(
        from activityPage: ActivityPage
    ) -> [HomeActivityItem] {
        return activityPage.activitys.map {
            HomeActivityItem(
                activity: $0
            )
        }
    }
    
    private func convertToNoticeViewItems(
        from activityPage: ActivityPage
    ) -> [HomeNoticeItem] {
        return activityPage.activitys.map {
            HomeNoticeItem(
                activity: $0
            )
        }
    }
    
    private func updateActivityPageData(receiveValue: ActivityPage) -> [HomeActivityItem] {
        let newItems = convertToActivityViewItems(from: receiveValue)
        
        var updateDataSource = activityItemsSubject.value ?? []
        
        updateDataSource.append(contentsOf: newItems)
        
        let uniquedData = Array(updateDataSource.uniqued())
        
        return uniquedData
    }
    
    private func updateNoticePageData(receiveValue: ActivityPage) -> [HomeNoticeItem] {
        let newItems = convertToNoticeViewItems(from: receiveValue)
        
        var updateDataSource = noticeItemsSubject.value ?? []
        
        updateDataSource.append(contentsOf: newItems)
        
        let uniquedData = Array(updateDataSource.uniqued())
        
        return uniquedData
    }
}
