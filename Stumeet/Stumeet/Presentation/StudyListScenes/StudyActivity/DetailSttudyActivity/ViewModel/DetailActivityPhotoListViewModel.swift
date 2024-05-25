//
//  DetailActivityPhotoListViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Foundation

final class DetailActivityPhotoListViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(imageURLs: [String], selectedRow: Int) {
        print(imageURLs, selectedRow)
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
