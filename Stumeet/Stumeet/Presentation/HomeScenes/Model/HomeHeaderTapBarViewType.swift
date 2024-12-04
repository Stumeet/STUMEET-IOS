//
//  HomeHeaderTapBarViewType.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/03.
//

import Foundation

enum HomeHeaderTapBarViewType: Int, CaseIterable {
    case task = 0
    case notice
    
    var title: String {
        switch self {
        case .task: "할 일"
        case .notice: "공지사항"
        }
    }
    
    var id: Int {
        self.rawValue
    }
}
