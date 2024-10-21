//
//  StudyMember.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/25.
//

import Foundation

struct StudyMember: Hashable {
    let id: Int
    let name: String
    let image: String
    let region: String
    let profession: String
    let isAdmin: Bool
    let achievement: Int?
    let canSendGrape: Bool?
    
    internal init(id: Int, name: String, image: String, region: String, profession: String, isAdmin: Bool, achievement: Int? = nil, canSendGrape: Bool? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.region = region
        self.profession = profession
        self.isAdmin = isAdmin
        self.achievement = achievement
        self.canSendGrape = canSendGrape
    }
}
