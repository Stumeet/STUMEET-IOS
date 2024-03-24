//
//  CreateActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Combine
import Foundation

final class CreateActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didChangeTitle: AnyPublisher<String?, Never>
        let didChangeContent: AnyPublisher<String?, Never>
        let didBeginEditing: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isBeginEditing: AnyPublisher<Bool, Never>
        let isEnableNextButton: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let content = input.didChangeContent
            .compactMap { $0 }
        
        let title = input.didChangeTitle
            .compactMap { $0 }

        let isEnableNextButton = Publishers.CombineLatest(content, title)
            .map { content, title in
                return !content.isEmpty && !title.isEmpty
            }
            .eraseToAnyPublisher()
        
        let isBeginEditing = input.didBeginEditing
            .map { _ in true }
            .eraseToAnyPublisher()
        
        return Output(
            isBeginEditing: isBeginEditing,
            isEnableNextButton: isEnableNextButton)
            
    }
}
