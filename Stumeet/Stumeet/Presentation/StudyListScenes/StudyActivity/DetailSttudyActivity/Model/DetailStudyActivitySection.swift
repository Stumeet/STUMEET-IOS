//
//  DetailStudyActivitySection.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import Foundation


enum DetailStudyActivitySection {
    case top
    case photo
    case bottom
}

enum DetailStudyActivitySectionItem: Hashable {
    case topCell(DetailStudyActivity.Top?)
    case photoCell(DetailStudyActivity.Photo?)
    case bottomCell(DetailStudyActivity.Bottom?)
}
