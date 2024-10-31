//
//  StudyMemberDetailViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/02.
//

import Combine
import Foundation

final class StudyMemberDetailViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let viewDidLoadTrigger: AnyPublisher<Void, Never>
        let didTapHeadderTapBarButton: AnyPublisher<StudyMemberDetailHeaderTapBarViewType, Never>
        let didReachTableBottom: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyMemberHeaderItem: AnyPublisher<StudyMemberDetailInfoHeaderItem, Never>
        let showMoreButtonState: AnyPublisher<Bool, Never>
        let activityDataSource: AnyPublisher<[StudyMemberActivityListItem], Never>
    }
    
    // MARK: - Properties
    private var studyId: Int
    private var studyMemberId: Int
    private var isNextPageLoading: Bool = false
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount}
    private var canLoadMorePages: Bool { hasMorePages && !isNextPageLoading }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var fetchStudyMemberDetailUseCase: FetchStudyMemberDetailUseCase
    private var fetchStudyMemberActivityUseCase: FetchStudyMemberActivityUseCase
    private var checkAdminUseCase: CheckAdminUseCase
    private var studyMemberHeaderItemSubject = CurrentValueSubject<StudyMemberDetailInfoHeaderItem?, Never>(nil)
    private var activityItemsSubject = CurrentValueSubject<[StudyMemberActivityListItem], Never>([])
    private var isStudyMemberAdminSubject = CurrentValueSubject<Bool, Never>(false)
    private var isCurrentUserAdminSubject = CurrentValueSubject<Bool, Never>(false)
    private var currentTap = CurrentValueSubject<ActivityCategory, Never>(.meeting)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchStudyMemberDetailUseCase: FetchStudyMemberDetailUseCase,
        fetchStudyMemberActivityUseCase: FetchStudyMemberActivityUseCase,
        checkAdminUseCase: CheckAdminUseCase,
        studyId: Int,
        studyMemberId: Int
    ) {
        self.fetchStudyMemberDetailUseCase = fetchStudyMemberDetailUseCase
        self.fetchStudyMemberActivityUseCase = fetchStudyMemberActivityUseCase
        self.checkAdminUseCase = checkAdminUseCase
        self.studyId = studyId
        self.studyMemberId = studyMemberId
    }
    
    func transform(input: Input) -> Output {
        let studyMemberHeaderItem = studyMemberHeaderItemSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let activityDataSource = activityItemsSubject.eraseToAnyPublisher()
        
        let showMoreButtonState = Publishers
            .CombineLatest(isStudyMemberAdminSubject, isCurrentUserAdminSubject)
            .map { isStudyMemberAdmin, isCurrentUserAdmin in
                return isCurrentUserAdmin && !isStudyMemberAdmin
            }
            .eraseToAnyPublisher()

        input.viewDidLoadTrigger
            .flatMap { [weak self] in
                guard let self else { return Empty<StudyMember, Never>().eraseToAnyPublisher() }
                return fetchStudyMemberDetailUseCase.execute(
                    studyID: self.studyId,
                    memberID: self.studyMemberId
                )
            }
            .sink { [weak self] memberItem in
                guard let self else { return }
                studyMemberHeaderItemSubject.send(StudyMemberDetailInfoHeaderItem(member: memberItem))
                isStudyMemberAdminSubject.send(memberItem.isAdmin)
            }
            .store(in: &cancellables)
        
        input.viewDidLoadTrigger
            .flatMap { [weak self] in
                guard let self else { return Empty<Bool, Never>().eraseToAnyPublisher()}
                return checkAdminUseCase.execute(studyID: studyId)
            }
            .sink { [weak self] isAdmin in
                guard let self else { return }
                isCurrentUserAdminSubject.send(isAdmin)
            }
            .store(in: &cancellables)
        
        input.viewDidLoadTrigger
            .handleEvents(receiveOutput: resetPages )
            .flatMap { [weak self] in
                guard let self else { return Empty<ActivityPage, Never>().eraseToAnyPublisher()}
                return fetchStudyMemberActivityUseCase.execute(
                    studyID: studyId,
                    memberID: studyMemberId,
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

                return fetchStudyMemberActivityUseCase.execute(
                    studyID: studyId,
                    memberID: studyMemberId,
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

                return fetchStudyMemberActivityUseCase.execute(
                    studyID: studyId,
                    memberID: studyMemberId,
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
            studyMemberHeaderItem: studyMemberHeaderItem,
            showMoreButtonState: showMoreButtonState,
            activityDataSource: activityDataSource
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
