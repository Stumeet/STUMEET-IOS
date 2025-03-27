//
//  MyViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import Combine
import Foundation

final class MyViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadData: AnyPublisher<Void, Never>
        let didTapHeadderTapBarButton: AnyPublisher<MyHeaderTapBarViewType, Never>
    }
    
    // MARK: - Output
    struct Output {
        let myHeaderItem: AnyPublisher<MyHeaderItem, Never>
        let headderTapType: AnyPublisher<MyHeaderTapBarViewType, Never>
        let evaluationDataSource: AnyPublisher<[MyEvaluationRow], Never>
    }
    
    // MARK: - Properties
    private var fetchMyProfileUseCase: FetchMyProfileUseCase
    private var fetchMemberReviewTagStatsUseCase: FetchMemberReviewTagStatsUseCase
    
    private var myHeaderItemSubject = CurrentValueSubject<MyHeaderItem?, Never>(nil)
    private var evaluationRowSubject = CurrentValueSubject<[MyEvaluationRow], Never>([])
    
    private var evaluationItems: [MyEvaluationItem] = []
    private var showSeeMore: Bool = false
    private var reviewOrderTitle: String = ""
    private var reviewItems: [MyReviewItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchMyProfileUseCase: FetchMyProfileUseCase,
        fetchMemberReviewTagStatsUseCase: FetchMemberReviewTagStatsUseCase
    ) {
        self.fetchMyProfileUseCase = fetchMyProfileUseCase
        self.fetchMemberReviewTagStatsUseCase = fetchMemberReviewTagStatsUseCase
    }
    
    func transform(input: Input) -> Output {
        let myHeaderItem = myHeaderItemSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let headderTapType = input.didTapHeadderTapBarButton
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let evaluationDataSource = evaluationRowSubject.eraseToAnyPublisher()

        
        // TODO: loadData 할떄 연동하기 API 연동하기
        input.loadData
            .flatMap(fetchMyProfileUseCase.execute)
            .sink { [weak self] userProfile in
                guard let self else { return }
                let convertedData: MyHeaderItem = .init(userProfile)
                myHeaderItemSubject.send(convertedData)
            }
            .store(in: &cancellables)
        
        input.loadData
            .flatMap(fetchMemberReviewTagStatsUseCase.execute)
            .sink { [weak self] totalCount, reviewTags in
                guard let self else { return }
                
                let items: [MyEvaluationItem] = reviewTags.map { .init(reviewTagData: $0, totalCount: totalCount) }
                updateEvaluationItems(items)
            }
            .store(in: &cancellables)
        
        return Output(
            myHeaderItem: myHeaderItem,
            headderTapType: headderTapType,
            evaluationDataSource: evaluationDataSource
        )
    }
    
    // MARK: - Function
    private func updateEvaluationItems(_ items: [MyEvaluationItem]) {
        self.evaluationItems = items
        buildEvaluationRows()
    }

    private func updateShowSeeMore(_ show: Bool) {
        self.showSeeMore = show
        buildEvaluationRows()
    }

    private func updateReviewOrderTitle(_ title: String) {
        self.reviewOrderTitle = title
        buildEvaluationRows()
    }

    private func updateReviewItems(_ items: [MyReviewItem]) {
        self.reviewItems = items
        buildEvaluationRows()
    }
    
    private func buildEvaluationRows() {
        var rows: [MyEvaluationRow] = []

        rows += evaluationItems.map { .evaluation($0) }
        rows.append(.evaluationSeeMore(showSeeMore))
        rows.append(.reviewOrder(reviewOrderTitle))
        rows += reviewItems.map { .review($0) }

        evaluationRowSubject.send(rows)
    }
}
