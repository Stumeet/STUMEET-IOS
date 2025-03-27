//
//  MyEvaluationItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import Foundation

struct MyEvaluationItem: Hashable {
    
    private let reviewTagData: ReviewTag
    private let totalCount: Int
    
    var isLastItem: Bool = false
    
    var title: String {
        reviewTagData.name
    }
    
    var count: Int {
        reviewTagData.count
    }
    
    var evaluationProgress: Float {
        Float(min(1, reviewTagData.count / totalCount))
    }
    
    init(reviewTagData: ReviewTag, totalCount: Int) {
        self.reviewTagData = reviewTagData
        self.totalCount = totalCount
    }
}
