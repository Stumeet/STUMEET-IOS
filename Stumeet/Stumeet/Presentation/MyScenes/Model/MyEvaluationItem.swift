//
//  MyEvaluationItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import Foundation

struct MyEvaluationItem: Hashable {
    var id: UUID = UUID()
    var isLastItem: Bool = false
    
    var title: String {
        "과제 성실도"
    }
    
    var count: Int {
        1
    }
    
    var totalCount: Int {
        10
    }
    
    var evaluationProgress: Float {
        0.7
    }
}
