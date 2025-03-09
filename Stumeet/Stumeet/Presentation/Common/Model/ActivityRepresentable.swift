//
//  ActivityRepresentable.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/04.
//

import Foundation

protocol ActivityRepresentable {
    var activity: Activity { get }
    var isTimeExpired: Bool? { get }
    var displayStudyName: String? { get }
    var displayActivityTitle: String? { get }
    var displayAuthorName: String { get }
    var displayType: ActivityCategory { get }
    var displayCreatedAt: String? { get }
    var displayStartTiem: String? { get }
    var displayEndTime: String? { get }
    var displayRemainingTime: String? { get }
}
