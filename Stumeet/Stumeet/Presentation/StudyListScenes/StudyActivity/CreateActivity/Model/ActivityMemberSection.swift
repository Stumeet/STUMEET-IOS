//
//  ActivityMemberSection.swift
//  Stumeet
//
//  Created by 정지훈 on 5/13/24.
//

import Foundation

// TODO: - 이미지 추가, dto에 따른 모델 추가

enum ActivityMemberSection {
    case main
}

enum ActivityMemberSectionItem: Hashable {
    case memberCell(String, Bool)
}

enum DetailActivityMemberSectionItem: Hashable {
    case memberCell(ActivityMember)
}
