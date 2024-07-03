//
//  TaskStudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import Combine
import Foundation

final class TaskStudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let reachedCollectionViewBottom: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyActivitySectionItem], Never>
    }
    
    // MARK: - Properties
    
    private let useCase: StudyActivityUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: StudyActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let itemSubject = CurrentValueSubject<[StudyActivitySectionItem], Never>([])
        
        let items = itemSubject.eraseToAnyPublisher()
        
        // 페이지 0번 데이터 받아오기
        useCase.getTaskActivityItems(items: [])
            .map { $0.map { StudyActivitySectionItem.task($0) } }
            .sink(receiveValue: itemSubject.send)
            .store(in: &cancellables)
        
        // 다음 페이지 받아오기
        input.reachedCollectionViewBottom
            .map { (itemSubject.value) }
            .flatMap(useCase.getTaskActivityItems)
            .map { $0.map { StudyActivitySectionItem.task($0) } }
            .sink(receiveValue: itemSubject.send)
            .store(in: &cancellables)
        
        return Output(
            items: items
        )
    }
}
