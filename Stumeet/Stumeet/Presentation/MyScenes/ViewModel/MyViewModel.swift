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
    }
    
    // MARK: - Properties
    private var myHeaderItemSubject = CurrentValueSubject<MyHeaderItem?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
    ) {
    }
    
    func transform(input: Input) -> Output {
        let myHeaderItem = myHeaderItemSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let headderTapType = input.didTapHeadderTapBarButton
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        input.loadData
            .sink { [weak self] _ in
                guard let self else { return }
                myHeaderItemSubject.send(MyHeaderItem())
            }
            .store(in: &cancellables)
        
        return Output(
            myHeaderItem: myHeaderItem,
            headderTapType: headderTapType
        )
    }
    
    // MARK: - Function
}
