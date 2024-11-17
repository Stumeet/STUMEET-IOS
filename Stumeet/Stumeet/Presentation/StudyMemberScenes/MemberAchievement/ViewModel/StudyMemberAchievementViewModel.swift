//
//  StudyMemberAchievementViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/11.
//

import Combine
import Foundation

final class StudyMemberAchievementViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadDataTrigger: AnyPublisher<Void, Never>
        let didTapHeadderTapBarButton: AnyPublisher<StudyMemberAchievementHeaderTapBarViewType, Never>
        let didReachTableBottom: AnyPublisher<Void, Never>
        let didSelectRow: AnyPublisher<IndexPath, Never>
    }

    // MARK: - Output
    struct Output {
        let activityDataSource: AnyPublisher<[StudyMemberActivityListItem], Never>
        let moveToMemberActivityDetailVC: AnyPublisher<(Int, Int, ActivityCategory), Never>
    }
    
    // MARK: - UseCase
    private var fetchAllStudyActivitiesUseCase: FetchAllStudyActivitiesUseCase
    
    // MARK: - Properties
    private var studyId: Int

    private var isNextPageLoading: Bool = false
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount}
    private var canLoadMorePages: Bool { hasMorePages && !isNextPageLoading }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var activityItemsSubject = CurrentValueSubject<[StudyMemberActivityListItem], Never>([])
    private var currentTap = CurrentValueSubject<ActivityCategory, Never>(.meeting)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchAllStudyActivitiesUseCase: FetchAllStudyActivitiesUseCase,
        studyId: Int
    ) {
        self.fetchAllStudyActivitiesUseCase = fetchAllStudyActivitiesUseCase
        self.studyId = studyId
    }
    
    func transform(input: Input) -> Output {
        
        let activityDataSource = activityItemsSubject.eraseToAnyPublisher()
        
        let moveToMemberActivityDetailVC = input.didSelectRow
            .compactMap { [weak self] indexPath -> (Int, Int, ActivityCategory)? in
                guard let self = self,
                      let rowItem = activityItemsSubject.value[safe: indexPath.row],
                      let type = rowItem.type
                else { return nil }
                
                return (studyId, rowItem.id, type)
            }
            .eraseToAnyPublisher()
        
        input.loadDataTrigger
            .handleEvents(receiveOutput: resetPages )
            .flatMap { [weak self] in
                guard let self else { return Empty<ActivityPage, Never>().eraseToAnyPublisher()}
                return fetchAllStudyActivitiesUseCase.execute(
                    studyID: studyId,
                    page: currentPage,
                    category: currentTap.value
                )
            }
            .map(updateActivityPageData(receiveValue:))
            .sink { [weak self] listItem in
                guard let self else { return }
                activityItemsSubject.send(listItem)
            }
            .store(in: &cancellables)
        
        input.didTapHeadderTapBarButton
            .handleEvents(
                receiveOutput: { [weak self] tapType in
                    guard let self else { return }
                    resetPages()
                    switch tapType.id {
                    case 0: currentTap.send(.meeting)
                    case 1: currentTap.send(.homework)
                    default: return
                    }
                }
            )
            .flatMap { [weak self] _ in
                guard let self else { return Empty<ActivityPage, Never>().eraseToAnyPublisher()}

                return fetchAllStudyActivitiesUseCase.execute(
                    studyID: studyId,
                    page: currentPage,
                    category: currentTap.value
                )
            }
            .map(updateActivityPageData(receiveValue:))
            .sink { [weak self] listItem in
                guard let self else { return }
                activityItemsSubject.send(listItem)
            }
            .store(in: &cancellables)
        
        input.didReachTableBottom
            .filter { [weak self] in self?.canLoadMorePages ?? false }
            .handleEvents(receiveOutput: { [weak self] in self?.isNextPageLoading = true })
            .flatMap { [weak self]  in
                guard let self else { return Empty<ActivityPage, Never>().eraseToAnyPublisher()}

                return fetchAllStudyActivitiesUseCase.execute(
                    studyID: studyId,
                    page: nextPage,
                    category: currentTap.value
                )
            }
            .handleEvents(receiveOutput: { [weak self] in self?.appendPage($0.pageInfo) })
            .map(updateActivityPageData(receiveValue:))
            .handleEvents(receiveOutput: { [weak self] _ in self?.isNextPageLoading = false })
            .sink(receiveValue: activityItemsSubject.send)
            .store(in: &cancellables)
        
        return Output(
            activityDataSource: activityDataSource,
            moveToMemberActivityDetailVC: moveToMemberActivityDetailVC
        )
    }
    
    // MARK: - Function
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        activityItemsSubject.send([])
    }
    
    private func appendPage(_ pageInfo: PageInfo) {
        currentPage = pageInfo.currentPage
        totalPageCount = pageInfo.totalPages
    }
    
    private func updateActivityPageData(receiveValue: ActivityPage) -> [StudyMemberActivityListItem] {
        let newItems = convertToActivityViewItems(from: receiveValue, cellType: .normal)
        
        var updateDataSource = activityItemsSubject.value
        
        updateDataSource.append(contentsOf: newItems)
        
        let uniquedData = Array(updateDataSource.uniqued())
        
        return uniquedData.enumerated().map { index, item in
            var updatedItem = item
            updatedItem.cellType = index == 0 ? .firstCell : .normal
            return updatedItem
        }
    }
    
    private func convertToActivityViewItems(
        from activityPage: ActivityPage,
        cellType: StudyMemberActivityListItem.StudyMemberActivityListCellStyle
    ) -> [StudyMemberActivityListItem] {
        return activityPage.activitys.map {
            StudyMemberActivityListItem(
                activity: $0,
                cellType: cellType,
                screenType: .detail
            )
        }
    }
}
