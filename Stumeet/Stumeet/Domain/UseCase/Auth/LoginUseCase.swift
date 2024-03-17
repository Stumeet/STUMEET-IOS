//
//  LoginUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Combine

protocol LoginUseCase {
    func singIn() -> AnyPublisher<Bool, Error>
}

final class DefaultLoginUseCase: LoginUseCase {
    private var service: LoginService
    
    init(service: LoginService) {
        self.service = service
    }

    func singIn() -> AnyPublisher<Bool, Error> {
        return service.fetchAuthToken()
    }
}
