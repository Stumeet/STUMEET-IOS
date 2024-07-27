//
//  String++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/24.
//

import Foundation

extension String {
    
    /// 24시간 형식의 시간 문자열을 12시간 형식(오전/오후)으로 변환
    ///
    /// 이 메서드는 "HH:mm:ss" 형식의 문자열을 받아 "a h:mm" 형식(예: 오후 6:00)으로  반환함
    /// 만약 입력 문자열이 유효하지 않거나 변환에 실패하면 nil 반환
    ///
    /// - Returns: 변환된 12시간 형식의 문자열 또는 nil
    func convertTimeFormat() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a h:mm"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.amSymbol = "오전"
        outputFormatter.pmSymbol = "오후"

        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
