//
//  AppleLogin.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/29.
//

import AuthenticationServices

class AppleLogin: NSObject, LoginProtocol {
    
    func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signOut(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
    
    func delete(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

extension AppleLogin:
    ASAuthorizationControllerPresentationContextProviding,
    ASAuthorizationControllerDelegate
{
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ((((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first)?.rootViewController)?.view.window!)!
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                UserDefaults.standard.setValue(identifyTokenString, forKey: PrototypeAPIConst.loginSnsToken)
                UserDefaults.standard.setValue(LoginType.apple.english, forKey: PrototypeAPIConst.loginType)
                PrototypeLoginManager.shared.login { oauth in
                    print("oauth result: \(oauth?.accessToken)")
                }
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
