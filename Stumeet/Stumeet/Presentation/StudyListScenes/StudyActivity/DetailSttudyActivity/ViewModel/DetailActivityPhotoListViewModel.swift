//
//  DetailActivityPhotoListViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

final class DetailActivityPhotoListViewModel: ViewModelType {
    
    struct Input {
        let didTapXButton: AnyPublisher<Void, Never>
        let didTapDownLoadButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let items: AnyPublisher<[DetailActivityPhotoSectionItem], Never>
        let dismiss: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let imageURLs: [String]
    private let selectedRow: Int
    
    init(imageURLs: [String], selectedRow: Int) {
        self.imageURLs = imageURLs
        self.selectedRow = selectedRow
    }
    
    func transform(input: Input) -> Output {
        
        let items = Just(imageURLs.map { DetailActivityPhotoSectionItem.photoCell($0) })
            .eraseToAnyPublisher()
        
        let dismiss = input.didTapXButton
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            dismiss: dismiss
        )
    }
    
}
