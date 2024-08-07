//
//  PageInfoResponseDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/28.
//

import Foundation

struct PageInfoResponseDTO: Decodable {
    let totalPages: Int
    let totalElements: Int
    let currentPage: Int
    let pageSize: Int
}

extension PageInfoResponseDTO {
    func toDomain() -> PageInfo {
        return .init(
            totalPages: totalPages,
            totalElements: totalElements,
            currentPage: currentPage,
            pageSize: pageSize
        )
    }
}
