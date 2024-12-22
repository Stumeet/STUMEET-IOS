//
//  AlarmListItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import Foundation

struct AlarmListItem: Hashable {
    let id: Int
    var title: String { "[자바를 자바] 공지사항이 변경되었어요 : 캠스터디 교재 1장 2번까지 풀이 하하하하하하" }
    var alertTime: String { "1시간 전" }
    var thumbnailImageUrl: String { "" }
}
