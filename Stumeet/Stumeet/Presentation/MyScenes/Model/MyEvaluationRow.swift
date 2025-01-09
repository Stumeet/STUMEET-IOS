//
//  MyEvaluationRow.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/10.
//

import Foundation

enum MyEvaluationRow: Hashable {
    case evaluation(MyEvaluationItem)
    case evaluationSeeMore(Bool)
    case reviewOrder(String)
    case review(MyReviewItem)
}
