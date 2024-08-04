//
//  CreateStudySelectItemType.swift
//  Stumeet
//
//  Created by 정지훈 on 7/31/24.
//

import Foundation

enum CreateStudySelectItemType {
    case field
    case region
}

extension CreateStudySelectItemType {
    var naviTitle: String {
        switch self {
        case .field:
            return "분야 선택"
        case .region:
            return "지역 선택"
        }
    }
    
    var explain: String {
        switch self {
        case .field:
            return "분야를 선택해주세요."
        case .region:
            return "지역을 선택해주세요."
        }
    }
}
