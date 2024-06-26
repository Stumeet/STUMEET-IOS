//
//  ActivityMember.swift
//  Stumeet
//
//  Created by 정지훈 on 6/17/24.
//

import Foundation

struct ActivityMember: Hashable {
    let id: Int
    let imageURL: String?
    let name: String
    var isSelected: Bool
}
