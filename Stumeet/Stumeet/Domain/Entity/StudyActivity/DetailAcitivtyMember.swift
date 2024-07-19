//
//  DetailAcitivtyMember.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import Foundation

struct DetailActivityMember: Hashable {
    let name: String?
    let state: ActivityState
    let profileImageURL: String?
}

enum ActivityState: String {
    case perform = "수행"
    case notperform = "미수행"
    case attendance = "출석"
    case absent = "결석"
    case late = "지각"
    case okAbsent = "인정결석"
    case okPerform = "지각제출"
    case noParticipation = "미참여"
    case beforeStart = "시작 전"
}
