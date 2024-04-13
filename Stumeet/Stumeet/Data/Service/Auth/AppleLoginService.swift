//
//  AppleLoginService.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/11.
//

import AuthenticationServices
import Combine

final class AppleLoginService: NSObject, LoginService {
    private var authCompletion: ((Result<String, Error>) -> Void)?

    func fetchAuthToken() -> AnyPublisher<String, Error> {
        return Future<String, Error> { [weak self] promise in
            self?.authCompletion = promise

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
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
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = appleIDCredential.identityToken,
              let idTokenString = String(data: idTokenData, encoding: .utf8)
        else {
            self.authCompletion?(.failure(NSError(domain: "AuthError", code: -1,
                                                  userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve ID Token"])))
            return
        }
        // TODO: 임시코드 삭제 예정
        UserDefaults.standard.setValue(idTokenString, forKey: PrototypeAPIConst.accessToken)
        self.authCompletion?(.success(idTokenString))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.authCompletion?(.failure(error))
    }
}
