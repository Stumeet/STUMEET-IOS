//
//  RegisterRequestDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 3/9/24.
//

import Foundation

struct RegisterRequestDTO: Encodable {
    let image: Data
    let nickname: String?
    let region: String?
    let profession: String?
}
