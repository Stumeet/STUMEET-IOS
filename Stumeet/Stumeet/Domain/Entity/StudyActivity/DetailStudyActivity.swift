//
//  DetailStudyActivity.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import Foundation

struct DetailStudyActivity {
    var top: Top?
    var photo: Photo?
    var bottom: Bottom?

    struct Top: Hashable {
        let id: Int
        let category: ActivityCategory
        let dayLeft: String?
        let status: String
        let profileImageURL: String
        let name: String
        let date: String
        let title: String
        let content: String
    }
    
    struct Photo: Hashable {
        let imageURL: [String]
    }
    
    struct Bottom: Hashable {
        let memberImageURL: [String?]
        let startDate: String?
        let endDate: String?
        let place: String?
    }
}
