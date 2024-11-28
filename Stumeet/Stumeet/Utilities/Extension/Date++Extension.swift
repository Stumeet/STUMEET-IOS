//
//  Date++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 9/1/24.
//

import Foundation

extension Date {
    private func dateFormatter(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }
    
    public var dateString: String {
        return dateFormatter("yyyy.MM.dd").string(from: self)
    }
    
    public func dateString(format: String = "yyyy.MM.dd") -> String {
        return dateFormatter(format).string(from: self)
    }
}
