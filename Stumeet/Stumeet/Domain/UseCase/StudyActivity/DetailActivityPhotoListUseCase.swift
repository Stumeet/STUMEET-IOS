//
//  DetailActivityPhotoListUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Combine
import Foundation

protocol DetailActivityPhotoListUseCase {
    func setPhotoItems(items: [String]) -> AnyPublisher<[DetailActivityPhotoSectionItem], Never>
    func setTitle(items: [String], currentPage: Int?, selectedRow: Int) -> AnyPublisher<String, Never>
    func setFirstItemIndexPath(selectedRow: Int) -> AnyPublisher<IndexPath, Never>
}

final class DefualtDetailActivityPhotoListUseCase: DetailActivityPhotoListUseCase {
    
    func setPhotoItems(items: [String]) -> AnyPublisher<[DetailActivityPhotoSectionItem], Never> {
        return Just(items.map { .photoCell($0) } ).eraseToAnyPublisher()
    }
    
    func setTitle(items: [String], currentPage: Int?, selectedRow: Int) -> AnyPublisher<String, Never> {
        let page = currentPage == nil ? selectedRow : currentPage! + 1
        return Just(String(items.count) + "장 중 \(page)번").eraseToAnyPublisher()
    }
    
    func setFirstItemIndexPath(selectedRow: Int) -> AnyPublisher<IndexPath, Never> {
        return Just(IndexPath(row: selectedRow, section: 0)).eraseToAnyPublisher()
    }
    
    
}
