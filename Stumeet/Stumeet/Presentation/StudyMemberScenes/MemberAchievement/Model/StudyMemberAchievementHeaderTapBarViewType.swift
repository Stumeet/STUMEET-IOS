//
//  StudyMemberAchievementHeaderTapBarViewType.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import Foundation

enum StudyMemberAchievementHeaderTapBarViewType: Int, CaseIterable {
    case meeting = 0
    case task
    
    var title: String {
        switch self {
        case .meeting: "모임"
        case .task: "과제"
        }
    }
    
    var id: Int {
        self.rawValue
    }
}
