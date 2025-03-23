//
//  MyHeaderItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import UIKit

struct MyHeaderItem {
    
    var profileImagePath: String {
        ""
    }
    
    var displayName: String {
        "홍길동"
    }
    
    var displayRegionAndField: String {
        "서울 · IT"
    }
    
    var currentExperience: Int {
        70
    }
    
    var expProgress: Float {
        0.7
    }
    
    var level: UserProfile.LevelStage {
        .flower
    }
    
    var grapeBunchCount: Int {
        23
    }
    
    var grapeBerryCount: Int {
        10
    }
    
    init(
    ) {
    }
}

