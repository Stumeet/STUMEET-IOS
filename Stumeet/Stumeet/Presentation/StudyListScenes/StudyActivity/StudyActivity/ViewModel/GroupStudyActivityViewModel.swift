//
//  GroupStudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import Combine
import Foundation

final class GroupStudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let reachedCollectionViewBottom: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[StudyActivitySectionItem], Never>
        let isEmptyItems: AnyPublisher<Bool, Never>
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
        useCase.getGroupActivityItems(items: [])
            .map { $0.map { StudyActivitySectionItem.group($0) } }
            .sink(receiveValue: itemSubject.send)
            .store(in: &cancellables)
        
        // 다음 페이지 받아오기
        input.reachedCollectionViewBottom
            .map { (itemSubject.value) }
            .flatMap(useCase.getGroupActivityItems)
            .map { $0.map { StudyActivitySectionItem.group($0) } }
            .sink(receiveValue: itemSubject.send)
            .store(in: &cancellables)
        
        let isEmptyItems = itemSubject
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            isEmptyItems: isEmptyItems
        )
    }
}
