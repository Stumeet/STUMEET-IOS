//
//  StudyMainViewDetailInfoItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/21.
//

import Foundation

struct StudyMainViewDetailInfoItem {
    
    let studyGroupDetail: StudyGroupDetail
    var intro: String { studyGroupDetail.intro }
    var rule: String { studyGroupDetail.rule }
    var region: String { studyGroupDetail.region }
    var tags: [String] { studyGroupDetail.tags.map { "#\($0)" } }
    var startDate: String { studyGroupDetail.startDate }
    var endDate: String { studyGroupDetail.endDate }
    var meetingTime: String { studyGroupDetail.meetingTime }
    var meetingRepetitionType: RepetitionType? { .init(rawValue: studyGroupDetail.meetingRepetitionType) }
    var meetingRepetitionDates: [String] { studyGroupDetail.meetingRepetitionDates }
    
    enum RepetitionType: String, CustomStringConvertible {
        case daily = "DAILY"
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
        
        var description: String {
            switch self {
            case .daily: return "매일"
            case .weekly: return "매주"
            case .monthly: return "매달"
            }
        }
    }
    
    enum DayOfWeek: String, CaseIterable {
        case monday = "월"
        case tuesday = "화"
        case wednesday = "수"
        case thursday = "목"
        case friday = "금"
        case saturday = "토"
        case sunday = "일"

        var fullName: String {
            switch self {
            case .monday: return "월요일"
            case .tuesday: return "화요일"
            case .wednesday: return "수요일"
            case .thursday: return "목요일"
            case .friday: return "금요일"
            case .saturday: return "토요일"
            case .sunday: return "일요일"
            }
        }
    }
    
    var period: String {
        let convertedStartDate = startDate.replacingOccurrences(of: "-", with: ".")
        let convertedEndDate = endDate.replacingOccurrences(of: "-", with: ".")
        
        return "\(convertedStartDate) ~ \(convertedEndDate)"
    }
    
    var recurringMeetingTime: String {
        let dateArray = convertRepetitionDates(elements: meetingRepetitionDates)
        let combinedDate = dateArray.joined(separator: " ")
        let time = meetingTime.convertTimeFormat() ?? "미정"
        let repetitionType = meetingRepetitionType?.description ?? "미정"
        
        return "\(repetitionType) \(combinedDate) \(time)"
    }
        
    private func convertRepetitionDates(elements: [String]) -> [String] {
        return elements.map { element in
            if let day = DayOfWeek(rawValue: element) {
                return day.fullName
            } else {
                return element
            }
        }
    }
}
