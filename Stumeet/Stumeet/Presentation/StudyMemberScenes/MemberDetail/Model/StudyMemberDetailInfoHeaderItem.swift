//
//  StudyMemberDetailInfoHeaderItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/20.
//

import Foundation

struct StudyMemberDetailInfoHeaderItem {
     
    private let member: StudyMember
    
    var displayName: String {
        member.name
    }
    
    var displayRegionAndField: String {
        "\(member.region) · \(member.profession)"
    }
    
    var isPraiseAvailable: Bool {
        member.canSendGrape ?? false
    }
    
    var achievementProgress: Int {
        member.achievement ?? 0
    }
    
    var imagePath: String {
        member.image
    }
    
    internal init(
        member: StudyMember
    ) {
        self.member = member
    }
}
