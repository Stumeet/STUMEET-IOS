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
    
    var level: LevelStage {
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

enum LevelStage: CaseIterable {
    case sprout
    case seed
    case leaf
    case flower
    case tree
    case fruit
    
    var title: String {
        switch self {
        case .sprout: "새싹"
        case .seed: "씨앗"
        case .leaf: "잎"
        case .flower: "꽃"
        case .tree: "나무"
        case .fruit: "열매"
        }
    }
    
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
}
