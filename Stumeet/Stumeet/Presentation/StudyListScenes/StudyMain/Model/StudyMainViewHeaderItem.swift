//
//  StudyMainViewHeaderItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/22.
//

import Foundation

struct StudyMainViewHeaderItem {
    
    let studyGroupDetail: StudyGroupDetail
    var title: String { studyGroupDetail.name }
    var thumbnailImageUrl: String { studyGroupDetail.image }
}
