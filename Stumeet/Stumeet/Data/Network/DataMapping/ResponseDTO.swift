//
//  ResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 3/1/24.
//

import Foundation

struct ResponseDTO: Decodable {
    let code: Int
    let message: String
}
