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
        let didTapFloatingButton: AnyPublisher<Void, Never>
        let didTapXButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedButtonIndex: AnyPublisher<Int, Never>
        let previousIndex: AnyPublisher<Int, Never>
        let slideIndex: AnyPublisher<Int, Never>
        let presentToCreateActivityVC: AnyPublisher<ActivityCategory, Never>
        let popViewController: AnyPublisher<Void, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let presentIndexSubject = CurrentValueSubject<Int, Never>(0)
        
        input.didSlideIndex
            .sink(receiveValue: presentIndexSubject.send)
            .store(in: &cancellables)
        
        let buttonTaps = Publishers.Merge3(
            input.didTapAllButton.map { 0 },
            input.didTapGroupButton.map { 1 },
            input.didTapTaskButton.map { 2 }
        )
        
        Publishers.Merge(buttonTaps, input.didSlideIndex)
            .sink(receiveValue: presentIndexSubject.send)
            .store(in: &cancellables)
        
        let selectedButtonIndex = buttonTaps
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let previousIndex = input.didChangedIndex
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let slideIndex = input.didSlideIndex.eraseToAnyPublisher()
        
        let presetnToCreateActivityVC = input.didTapFloatingButton
            .map { presentIndexSubject.value }
            .compactMap { index -> ActivityCategory? in
                switch index {
                case 0: return .freedom
                case 1: return .meeting
                case 2: return .homework
                default: return nil
                }
            }
            .eraseToAnyPublisher()
        
        return Output(
            selectedButtonIndex: selectedButtonIndex,
            previousIndex: previousIndex,
            slideIndex: slideIndex,
            presentToCreateActivityVC: presetnToCreateActivityVC,
            popViewController: input.didTapXButton
        )
    }
    
}
