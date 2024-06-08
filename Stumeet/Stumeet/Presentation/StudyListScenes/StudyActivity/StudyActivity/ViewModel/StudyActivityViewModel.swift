//
//  StudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import Foundation
import Combine

final class StudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapAllButton: AnyPublisher<Void, Never>
        let didTapGroupButton: AnyPublisher<Void, Never>
        let didTapTaskButton: AnyPublisher<Void, Never>
        let didChangedIndex: AnyPublisher<Int, Never>
        let didSlideIndex: AnyPublisher<Int, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedButtonIndex: AnyPublisher<Int, Never>
        let previousIndex: AnyPublisher<Int, Never>
        let slideIndex: AnyPublisher<Int, Never>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let selectedButtonIndex = Publishers.Merge3(
            input.didTapAllButton.map { 0 },
            input.didTapGroupButton.map { 1 },
            input.didTapTaskButton.map { 2 }
        )
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let previousIndex = input.didChangedIndex
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(
            selectedButtonIndex: selectedButtonIndex,
            previousIndex: previousIndex,
            slideIndex: input.didSlideIndex.eraseToAnyPublisher()
        )
    }
    
}
