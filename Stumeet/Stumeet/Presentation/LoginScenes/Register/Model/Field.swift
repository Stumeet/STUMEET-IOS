//
//  Field.swift
//  Stumeet
//
//  Created by 정지훈 on 2/16/24.
//

import Foundation

enum FieldSection: Hashable {
    case main
}

struct Field: Hashable {
    let field: String
    var isSelected: Bool
}

extension Field {
    static let list: [Field] = {[
        Field(field: "IT", isSelected: false),
        Field(field: "출판", isSelected: false),
        Field(field: "디자인", isSelected: false),
        Field(field: "마케팅/기획", isSelected: false),
        Field(field: "어학", isSelected: false),
        Field(field: "취업준비", isSelected: false),
        Field(field: "자연계", isSelected: false),
        Field(field: "방송", isSelected: false),
        Field(field: "자율스터디", isSelected: false),
        Field(field: "경제", isSelected: false),
        Field(field: "자격증", isSelected: false),
        Field(field: "인문계", isSelected: false),
        Field(field: "봉사활동", isSelected: false)
    ]}()
}
