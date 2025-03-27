//
//  MyHeaderItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import UIKit

struct MyHeaderItem {
    
    private(set) var userProfileData: UserProfile
    
    var profileImagePath: String? {
        userProfileData.profileImage
    }
    
    var displayName: String {
        userProfileData.nickname ?? "알 수 없음"
    }
    
    var displayRegionAndField: String {
        "\(userProfileData.region ?? "알 수 없음") · \(userProfileData.profession ?? "알 수 없음")"
    }
    
    var currentExperience: Int {
        Int(userProfileData.experience)
    }
    
    var expProgress: Float {
        guard let nextTier = userProfileData.tier.next else { return 0 }
        let calculateValue = min(1, currentExperience / nextTier.requiredExperience)
        return Float(calculateValue)
    }
    
    var level: UserProfile.LevelStage {
        userProfileData.tier
    }
    
    var grapeBunchCount: Int {
        userProfileData.grapeCount / 15
    }
    
    var grapeBerryCount: Int {
        userProfileData.grapeCount % 15
    }
    
    init(_ userProfileData: UserProfile) {
        self.userProfileData = userProfileData
    }
}
