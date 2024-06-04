//
//  StudyActivitySection.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import Foundation

// TODO: - API 연동에 따른 DTO 수정

enum StudyActivitySection {
    case main
}

enum StudyActivityItem: Hashable {
    case all(Activity?)
    case group(Activity?)
    case task(Activity?)
}
