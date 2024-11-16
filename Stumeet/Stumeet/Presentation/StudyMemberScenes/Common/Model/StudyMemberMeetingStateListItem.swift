//
//  StudyMemberMeetingStateListItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/05.
//

import UIKit

struct StudyMemberMeetingStateListItem: Hashable, Identifiable {
    
    private var detailActivityMember: DetailActivityMember
    let category: ActivityCategory
    var id: Int? { detailActivityMember.id }
    var isStateHidden: Bool = true
    
    var name: String {
        detailActivityMember.name ?? "-"
    }
    
    var profileImage: String? {
        detailActivityMember.profileImageURL
    }
    
    var activityState: ActivityState {
        get {
            detailActivityMember.state
        }
        set {
            detailActivityMember.state = newValue
        }
    }
    
    init(detailActivityMember: DetailActivityMember, category: ActivityCategory) {
        self.detailActivityMember = detailActivityMember
        self.category = category
    }
}
