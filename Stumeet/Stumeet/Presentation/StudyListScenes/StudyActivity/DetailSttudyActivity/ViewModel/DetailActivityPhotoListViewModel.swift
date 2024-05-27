//
//  DetailActivityPhotoListViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

final class DetailActivityPhotoListViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapXButton: AnyPublisher<Void, Never>
        let currentPage: AnyPublisher<Int?, Never>
        let didTapDownLoadButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[DetailActivityPhotoSectionItem], Never>
        let title: AnyPublisher<String, Never>
        let firstItem: AnyPublisher<IndexPath, Never>
        let checkPermission: AnyPublisher<Int, Never>
        let dismiss: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: DetailActivityPhotoListUseCase
    private let imageURLs: [String]
    private let selectedRow: Int
    
    // MARK: - Init
    
    init(useCase: DetailActivityPhotoListUseCase, imageURLs: [String], selectedRow: Int) {
        self.useCase = useCase
        self.imageURLs = imageURLs
        self.selectedRow = selectedRow
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.setPhotoItems(items: imageURLs)
        
        let title = input.currentPage
            .removeDuplicates()
            .map { (self.imageURLs, $0, self.selectedRow) }
            .flatMap(useCase.setTitle)
            .eraseToAnyPublisher()
        
        let firstItem = useCase.setFirstItemIndexPath(selectedRow: selectedRow)
        
        let checkPermission = input.didTapDownLoadButton
            .zip(input.currentPage)
            .map { $1 ?? self.selectedRow}
            .eraseToAnyPublisher()
        
        let dismiss = input.didTapXButton
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            title: title,
            firstItem: firstItem,
            checkPermission: checkPermission,
            dismiss: dismiss
        )
    }
    
}
