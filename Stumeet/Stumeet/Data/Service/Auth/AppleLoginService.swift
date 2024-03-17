//
//  AppleLoginService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import AuthenticationServices
import Combine

final class AppleLoginService: NSObject, LoginService {
    private var authCompletion: ((Result<Bool, Error>) -> Void)?
    
    func fetchAuthToken() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            self.authCompletion = promise
            
            // Apple ID 인증 요청 구성 및 실행
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
        .eraseToAnyPublisher()
    }
}

extension AppleLoginService:
    ASAuthorizationControllerPresentationContextProviding,
    ASAuthorizationControllerDelegate {
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("Active window scene not found")
        }
        return mainWindow
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let idTokenData = appleIDCredential.identityToken,
           let idTokenString = String(data: idTokenData, encoding: .utf8) {
            
            // UserDefaults에 idToken 저장
            UserDefaults.standard.set(idTokenString, forKey: "idToken")
            authCompletion?(.success(true))
        } else {
            authCompletion?(.failure(NSError(domain: "AuthError", code: -1, userInfo: nil)))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authCompletion?(.failure(error))
    }
}
