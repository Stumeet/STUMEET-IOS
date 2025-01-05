//
//  MyHeaderTapBarViewType.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import Foundation

enum MyHeaderTapBarViewType: Int, CaseIterable {
    case evaluation = 0
    case activity
    
    var title: String {
        switch self {
        case .evaluation: "받은 평가"
        case .activity: "활동 내역"
        }
    }
    
    var id: Int {
        self.rawValue
    }
}
