//
//  LoginService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/14.
//

import Combine

protocol LoginService {
    func fetchAuthToken() -> AnyPublisher<String, Error>
}
