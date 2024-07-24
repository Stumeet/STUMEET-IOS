//
//  LoginUseCase.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import Combine
import Foundation

enum LoginType {
    case apple
    case kakao
    
    var korean: String {
        switch self {
        case .apple:
            return "애플"
        case .kakao:
            return "카카오"
        }
    }
    
    var english: String {
        switch self {
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        }
    }
}

protocol LoginUseCase {
    func signIn(loginType: LoginType) -> AnyPublisher<Bool, Error>
}

final class DefaultLoginUseCase: LoginUseCase {
    private var kakaoLoginService: LoginService
    private var appleLoginService: LoginService
    private let repository: LoginRepository

    init(kakaoLoginService: LoginService,
         appleLoginService: LoginService,
         repository: LoginRepository
    ) {
        self.kakaoLoginService = kakaoLoginService
        self.appleLoginService = appleLoginService
        self.repository = repository
    }
    
    func signIn(loginType: LoginType) -> AnyPublisher<Bool, Error> {
        let selectedService: LoginService = {
            switch loginType {
            case .kakao:
                return kakaoLoginService
            case .apple:
                return appleLoginService
            }
        }()
        
        return processLogin(with: selectedService, loginType: loginType)
    }
    
    private func processLogin(with service: LoginService, loginType: LoginType) -> AnyPublisher<Bool, Error> {
        return service.fetchAuthToken()
            .flatMap { [weak self] snsToken -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }

                return repository.requestLogin(loginType: loginType, snsToken: snsToken)
                    .map { $0 }
                    .catch { error in
                        Fail(error: error).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
