//
//  MyStudyGroupListType.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/09.
//

import Foundation

enum MyStudyGroupListType: CustomStringConvertible {
    
    case active
    case finished
    
    var description: String {
        switch self {
        case .active:
            return "ACTIVE"
        case .finished:
            return "FINISHED"
        }
    }
}
