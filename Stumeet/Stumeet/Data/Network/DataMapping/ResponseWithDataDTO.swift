//
//  ResponseWithDataDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/30.
//

import Foundation

struct ResponseWithDataDTO<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T
}
