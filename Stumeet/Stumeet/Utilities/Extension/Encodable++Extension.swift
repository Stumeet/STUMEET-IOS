//
//  Encodable++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 3/2/24.
//

import Foundation

import Foundation

extension Encodable {
    
    /// Request parameter를 encoding해 dictionary로 바꿔줍니다.
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
