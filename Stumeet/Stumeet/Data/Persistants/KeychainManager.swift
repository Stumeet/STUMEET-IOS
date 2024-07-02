//
//  KeychainManager.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/18.
//

import Foundation
import Security

protocol KeychainManageable {
    func saveToken(_ token: AuthToken) -> Bool
    func removeAllTokens() -> Bool
    func getToken() -> AuthToken?
}

final class KeychainManager: KeychainManageable {
    private let authTokenKey = "authToken"
    private var cachedToken: AuthToken?
    
    func saveToken(_ token: AuthToken) -> Bool {
        guard let tokenData = try? JSONEncoder().encode(token) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: authTokenKey,
            kSecValueData as String: tokenData
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        let isSuccess = status == errSecSuccess
        
        if isSuccess {
            cachedToken = token
        }
        
        return isSuccess
    }
    
    func getToken() -> AuthToken? {
        if let token = cachedToken { return token }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: authTokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let token = try? JSONDecoder().decode(AuthToken.self, from: data)
        else { return nil }
        
        cachedToken = token
        return token
    }
    
    func removeAllTokens() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: authTokenKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        let isSuccess = status == errSecSuccess
        
        if isSuccess {
            cachedToken = nil
        }
        
        return isSuccess
    }
}
