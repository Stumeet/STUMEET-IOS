//
//  MyReviewItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import Foundation

struct MyReviewItem: Hashable {
    var id: UUID = UUID()
    var starCount: Int {
        3
    }
    
    var reviewText: String {
        """
 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고
         최고의 팀원! 어쩌고 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고
         최고의 팀원! 어쩌고 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고
         최고의 팀원! 어쩌고 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고
         최고의 팀원! 어쩌고 최고의 팀원! 어쩌고 저쩌고 최고의 팀원! 어쩌고
 """
    }
    
    var displayDate: String {
        "2024.01.10"
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
}
