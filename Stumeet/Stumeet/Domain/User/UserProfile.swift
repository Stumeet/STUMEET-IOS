//
//  UserProfile.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/23/25.
//

import Foundation

struct UserProfile {
    let id: Int
    let profileImage: String?
    let nickname: String?
    let region: String?
    let profession: String?
    let tier: LevelStage
    let experience: Double
    let grapeCount: Int
    
    enum LevelStage: String, CaseIterable {
        case sprout = "새싹"
        case seed = "씨앗"
        case leaf = "잎"
        case flower = "꽃"
        case tree = "나무"
        case fruit = "열매"
        
        var requiredExperience: Int {
            switch self {
            case .sprout: 20
            case .seed: 100
            case .leaf: 500
            case .flower: 1000
            case .tree: 2000
            case .fruit: -1
            }
        }
        
        var imageName: ImageResource {
            switch self {
            case .sprout: .My.seed
            case .seed: .My.seeding
            case .leaf: .My.leaf
            case .flower: .My.flower
            case .tree: .My.tree
            case .fruit: .My.group
            }
        }
        
        var next: LevelStage? {
            guard let currentIndex = Self.allCases.firstIndex(of: self),
                  currentIndex + 1 < Self.allCases.count else {
                return nil
            }
            return Self.allCases[currentIndex + 1]
        }
    }
}
