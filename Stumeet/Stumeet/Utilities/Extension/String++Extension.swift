//
//  String++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 7/3/24.
//

import Foundation

extension String {
    
    /// createdAt 날짜를 x분/일/주/달 전으로 바꿔주는 함수입니다.
    /// - Returns: x분/일/주/달 전
    func timeAgoSince() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: date, to: now)
        
        if let year = components.year, year >= 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return dateFormatter.string(from: date)
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)개월 전"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)주 전"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)일 전"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        }
        
        return "방금 전"
    }
    
    /// 날짜를 "yyyy. M. d(E) a h:mm" 형식으로 바꿔주는 함수입니다.
    /// - Returns: 포맷된 날짜 문자열
    func formattedDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let koreanLocale = Locale(identifier: "ko_KR")
        dateFormatter.locale = koreanLocale
        dateFormatter.dateFormat = "yyyy. M. d(E) a h:mm"
        return dateFormatter.string(from: date)
    }
    
    /// 날짜를 "yyyy.MM.dd HH:mm" 형식으로 바꿔주는 함수입니다.
    /// - Returns: 포맷된 날짜 문자열
    func formattedDateHHmm() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let koreanLocale = Locale(identifier: "ko_KR")
        dateFormatter.locale = koreanLocale
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    /// 종료 날짜를 기준으로 몇년/개월/주/일/시간/분 남음으로 바꿔주는 함수입니다.
    /// - Returns: x년/개월/주/일/시간/분 남음
    func timeUntilSince() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let endDate = dateFormatter.date(from: self) else { return nil }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: now, to: endDate)
        
        if let year = components.year, year >= 1 {
            return "\(year)년 남음"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)달 남음"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)주 남음"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)일 남음"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 남음"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 남음"
        }
        
        return "0분 남음"
    }
}
