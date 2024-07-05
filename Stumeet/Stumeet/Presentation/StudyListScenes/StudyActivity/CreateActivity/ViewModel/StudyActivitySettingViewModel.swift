//
//  StudyActivitySettingViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import Combine
import Foundation

final class StudyActivitySettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapStartDateButton: AnyPublisher<Void, Never>
        let didTapEndDateButton: AnyPublisher<Void, Never>
        let didTapPlaceButton: AnyPublisher<Void, Never>
        let didTapMemeberButton: AnyPublisher<Void, Never>
        let didSelectedMembers: AnyPublisher<[ActivityMember], Never>
        let didTapPostButton: AnyPublisher<Void, Never>
        let didTapBackButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let currentCategory: AnyPublisher<ActivityCategory, Never>
        let currentDates: AnyPublisher<(String, String), Never>
        let showCalendarIsStart: AnyPublisher<Bool, Never>
        let presentToPlaceVC: AnyPublisher<Void, Never>
        let presentToParticipatingMemberVC: AnyPublisher<Void, Never>
        let selectedMembers: AnyPublisher<[ActivityMember], Never>
        let popViewController: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let activity: CreateActivity
    
    // MARK: - Init
    
    init(activity: CreateActivity) {
        self.activity = activity
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let currentDates = Just(getCurrentFormattedDates())
            .eraseToAnyPublisher()
        let showCalendarIsStart = Publishers.Merge(
            input.didTapStartDateButton.map { true },
            input.didTapEndDateButton.map { false }
        )
            .eraseToAnyPublisher()
        let presentToPlaceVC = input.didTapPlaceButton
        let presentToMemberVC = input.didTapMemeberButton
        
        return Output(
            currentCategory: Just(activity.category).eraseToAnyPublisher(),
            currentDates: currentDates,
            showCalendarIsStart: showCalendarIsStart,
            presentToPlaceVC: presentToPlaceVC,
            presentToParticipatingMemberVC: presentToMemberVC,
            selectedMembers: input.didSelectedMembers,
            popViewController: input.didTapBackButton
        )
    }
}

extension StudyActivitySettingViewModel {
    func getCurrentFormattedDates() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. M. d(EEE) a h:mm"
        
        let now = Date()
        let calendar = Calendar.current
        let roundedMinutes = (calendar.component(.minute, from: now) + 4) / 5 * 5
        var components = DateComponents(
            year: calendar.component(.year, from: now),
            month: calendar.component(.month, from: now),
            day: calendar.component(.day, from: now),
            hour: calendar.component(.hour, from: now),
            minute: roundedMinutes
        )
        let roundedStartDate = calendar.date(from: components)!
        
        
        components.hour = calendar.component(.hour, from: now) + 1
        let roundedEndDate = calendar.date(from: components)!
        
        let currentStartDate = dateFormatter.string(from: roundedStartDate)
        let currentEndDate = dateFormatter.string(from: roundedEndDate)
        
        return (currentStartDate, currentEndDate)
    }
}
