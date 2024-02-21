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

struct AddableField: Hashable {
    let field: String
}


extension Field {
    static var list: [Field] = [
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
    ]
}

extension AddableField {
    static var list: [AddableField] = [
        AddableField(field: "UXUI 디자인"),
        AddableField(field: "영상 디자인"),
        AddableField(field: "산업 디자인"),
        AddableField(field: "그래픽 디자인"),
        AddableField(field: "편집 디자인"),
        AddableField(field: "테스트1"),
        AddableField(field: "테스트2"),
        AddableField(field: "테스트3"),
        AddableField(field: "테스트4")
    ]
}
