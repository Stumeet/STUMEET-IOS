//
//  SnsLoginViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import Combine

final class SnsLoginViewModel: ViewModelType {
    var loginSnsManger: LoginProtocol?
    // MARK: - Input
    struct Input {
        let didTapAppleButton: AnyPublisher<LoginType, Never>
    }

    // MARK: - Output
    struct Output {
        let signInOut: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let signIn = input.didTapAppleButton
            .map { [weak self] type in
                guard let self = self else { return }
                self.loginSnsManger = self.setDelegate(type)
            }
            .eraseToAnyPublisher()
        
        return Output(
            signInOut: signIn
        )
    }
    
    private func setDelegate(_ loginType: LoginType) -> LoginProtocol? {
        switch loginType {
        case .apple:
            return AppleLogin()
        case .kakao:
            return AppleLogin()
        default:
            return nil
        }
    }
}

enum LoginType {
    case apple
    case kakao
    case none
    
    var korean: String {
        switch self {
        case .apple:
            return "애플"
        case .kakao:
            return "카카오"
        default:
            return ""
        }
    }
    
    var english: String {
        switch self {
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        default:
            return ""
        }
    }
}
