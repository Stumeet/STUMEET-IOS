//
//  ScheduleViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import Foundation
import Combine
import Algorithms

final class ScheduleViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadData: AnyPublisher<Void, Never>
        let reachedTableViewBottom: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    struct Output {
    }
    
    // MARK: - Properties
    private var studyID: Int
    private var isNextPageLoading: Bool = false
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount}
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var canLoadMorePages: Bool { hasMorePages && !isNextPageLoading }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        studyID: Int
    ) {
        self.studyID = studyID
    }
    
    func transform(input: Input) -> Output {
    
        return Output(
        )
    }
    
    // MARK: - Function
}

