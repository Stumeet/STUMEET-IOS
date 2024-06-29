//
//  KeychainManager.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/18.
//

import Foundation
import Security

enum TokenKey: CaseIterable {
    case accessToken
    case refreshToken
    
    var key: String {
        switch self {
        case .accessToken:
            return "ACCESS_TOKEN"
        case .refreshToken:
            return "REFRESH_TOKEN"
        }
    }
}

protocol KeychainManageable {
    func saveToken(_ token: String, for key: TokenKey) -> Bool
    func removeToken(for key: TokenKey) -> Bool
    @discardableResult func removeAllTokens() -> Bool
    func getToken(for key: TokenKey) -> String?
}

final class KeychainManager: KeychainManageable {
    func saveToken(_ token: String, for key: TokenKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.key,
            kSecValueData as String: token.data(using: .utf8)!
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func removeToken(for key: TokenKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    @discardableResult func removeAllTokens() -> Bool {
        var allRemoved = true
        TokenKey.allCases.forEach { key in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.key
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            if status != errSecSuccess {
                allRemoved = false
            }
        }
        return allRemoved
    }
    
    func getToken(for key: TokenKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
