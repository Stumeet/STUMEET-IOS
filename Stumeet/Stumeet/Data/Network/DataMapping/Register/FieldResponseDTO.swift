//
//  FieldResponseDTO.swift
//  Stumeet
//
//  Created by 정지훈 on 3/2/24.
//

import Foundation

struct FieldResponseDTO: Decodable {
    let code: Int
    let message: String
    let data: ProfessionResponseDTO
}

extension FieldResponseDTO {
    struct ProfessionResponseDTO: Decodable {
        let professions: [FieldDTO]
    }
}

extension FieldResponseDTO.ProfessionResponseDTO {
    struct FieldDTO: Decodable {
        let id: Int
        let name: String
    }
}

extension FieldResponseDTO.ProfessionResponseDTO.FieldDTO {
    func toDomain() -> Field {
        return .init(id: id, name: name, isSelected: false)
    }
}
