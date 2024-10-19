//
//  FCMTokenRequestDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/18.
//

import Foundation

struct FCMTokenRequestDTO: Encodable {
    let deviceId: String
    let notificationToken: String
}
