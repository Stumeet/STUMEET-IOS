//
//  ActivityMemberSettingRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 5/17/24.
//

import Combine
import Foundation

protocol ActivityMemberSettingRepository {
    func fetchMembers() -> AnyPublisher<[ActivityMember], Never> 
}
