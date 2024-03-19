//
//  PrototypeOauth.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Foundation

struct PrototypeOauth: Codable {
    var accessToken: String?
    var refreshToken: String?
    var isFirstLogin: Bool?
    
    enum CodingKeys: CodingKey {
        case accessToken
        case refreshToken
        case isFirstLogin
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<PrototypeOauth.CodingKeys> = try decoder.container(keyedBy: PrototypeOauth.CodingKeys.self)
        
        self.accessToken = try container.decodeIfPresent(String.self, forKey: PrototypeOauth.CodingKeys.accessToken)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: PrototypeOauth.CodingKeys.refreshToken)
        self.isFirstLogin = try container.decodeIfPresent(Bool.self, forKey: PrototypeOauth.CodingKeys.isFirstLogin)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<PrototypeOauth.CodingKeys> = encoder.container(keyedBy: PrototypeOauth.CodingKeys.self)
        
        try container.encodeIfPresent(self.accessToken, forKey: PrototypeOauth.CodingKeys.accessToken)
        try container.encodeIfPresent(self.refreshToken, forKey: PrototypeOauth.CodingKeys.refreshToken)
        try container.encodeIfPresent(self.isFirstLogin, forKey: PrototypeOauth.CodingKeys.isFirstLogin)
    }
}
