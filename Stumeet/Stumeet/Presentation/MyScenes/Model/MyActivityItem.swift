//
//  MyActivityItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/10.
//

import Foundation

struct MyActivityItem: Hashable {
    var id: UUID = UUID()
    
    var displayTitle: String {
        "제목"
    }
    
    var displayTime: String {
        "2024.02.00 ~ 2024.02.00"
    }
    
    var tags: [String] {
        [
            "분위기 메이커",
            "시간을 잘 지켜요",
            "열정",
            "열정 같은",
            "성실",
            "성실 하까 마까",
            "성실 하까",
            "성실 하"
        ]
    }
    
    var isReviewRequired: Bool {
        true
    }
}
