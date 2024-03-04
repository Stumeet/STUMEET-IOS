//
//  Field.swift
//  Stumeet
//
//  Created by 정지훈 on 3/2/24.
//

import Foundation

struct Field: Hashable {
    let id: Int
    let name: String
    var isSelected: Bool
}

extension Field {
    static var data: [Field] = [
        Field(id: 1, name: "경영사무", isSelected: false),
        Field(id: 19, name: "마케팅·광고·홍보", isSelected: false),
        Field(id: 25, name: "디자인", isSelected: false),
        Field(id: 37, name: "무역·유통", isSelected: false),
        Field(id: 41, name: "영업·고객상담", isSelected: false),
        Field(id: 46, name: "서비스", isSelected: false),
        Field(id: 52, name: "연구개발·설계", isSelected: false),
        Field(id: 19, name: "교육", isSelected: false),
        Field(id: 57, name: "건설·건축", isSelected: false),
        Field(id: 67, name: "미디어·문화", isSelected: false),
        Field(id: 82, name: "전문·특수·연구직", isSelected: false),
        Field(id: 106, name: "IT", isSelected: false),
        Field(id: 124, name: "의료", isSelected: false)
    ]
}
