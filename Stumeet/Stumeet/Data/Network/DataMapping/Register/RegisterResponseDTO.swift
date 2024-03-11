//
//  RegisterResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 3/11/24.
//

import Foundation

struct RegisterResponseDTO: Decodable {
    let code: Int
    let message: String
}
