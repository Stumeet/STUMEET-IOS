//
//  NicknameRepository.swift
//  Stumeet
//
//  Created by 정지훈 on 3/1/24.
//

import Combine
import Foundation

import Moya

protocol NicknameRepository {
    func checkDuplicateNickname(nickname: String) -> AnyPublisher<ResponseDTO, MoyaError>
}
