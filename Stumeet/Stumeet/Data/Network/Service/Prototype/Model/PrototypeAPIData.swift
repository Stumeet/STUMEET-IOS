//
//  PrototypeAPIData.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Foundation

struct PrototypeAPIData<T: Codable>: Codable {
    var message: String
    var code: Int
    var data: T?
    
    enum CodingKeys: CodingKey {
        case message
        case code
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<PrototypeAPIData<T>.CodingKeys> = try decoder.container(keyedBy: PrototypeAPIData<T>.CodingKeys.self)
        
        self.message = try container.decode(String.self, forKey: PrototypeAPIData<T>.CodingKeys.message)
        self.code = try container.decode(Int.self, forKey: PrototypeAPIData<T>.CodingKeys.code)
        self.data = try container.decodeIfPresent(T.self, forKey: PrototypeAPIData<T>.CodingKeys.data)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<PrototypeAPIData<T>.CodingKeys> = encoder.container(keyedBy: PrototypeAPIData<T>.CodingKeys.self)
        
        try container.encode(self.message, forKey: PrototypeAPIData<T>.CodingKeys.message)
        try container.encode(self.code, forKey: PrototypeAPIData<T>.CodingKeys.code)
        try container.encodeIfPresent(self.data, forKey: PrototypeAPIData<T>.CodingKeys.data)
    }
}
