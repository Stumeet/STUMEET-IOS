//
//  StudyMemberRemoveRequestDTO.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/10/31.
//

import Foundation

struct StudyMemberRemoveRequestDTO: Encodable {
    let studyId: Int
    let memberId: Int
}
