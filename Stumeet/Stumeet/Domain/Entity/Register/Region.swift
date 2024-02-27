//
//  Region.swift
//  Stumeet
//
//  Created by 정지훈 on 2/27/24.
//

import Foundation

struct Region: Hashable {
    let region: String
    var isSelected: Bool
}

extension Region {
    static var list: [Region] = {[
        Region(region: "서울", isSelected: false),
        Region(region: "인천/경기", isSelected: false),
        Region(region: "전북", isSelected: false),
        Region(region: "전남", isSelected: false),
        Region(region: "강원", isSelected: false),
        Region(region: "경북", isSelected: false),
        Region(region: "경남", isSelected: false),
        Region(region: "충북", isSelected: false),
        Region(region: "충남", isSelected: false),
        Region(region: "제주", isSelected: false)
    ]}()
}
