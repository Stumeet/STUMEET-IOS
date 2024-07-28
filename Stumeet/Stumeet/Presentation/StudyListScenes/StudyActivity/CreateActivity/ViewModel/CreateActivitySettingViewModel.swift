//
//  StudyActivitySettingViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import Combine
import Foundation

final class CreateActivitySettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapStartDateButton: AnyPublisher<Void, Never>
        let didTapEndDateButton: AnyPublisher<Void, Never>
        let didTapPlaceButton: AnyPublisher<Void, Never>
        let didEnterPlace: AnyPublisher<String?, Never>
        let didTapMemeberButton: AnyPublisher<Void, Never>
        let didSelectMembers: AnyPublisher<[ActivityMember], Never>
        let didTapPostButton: AnyPublisher<Void, Never>
        let didTapBackButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let currentCategory: AnyPublisher<ActivityCategory, Never>
        let currentStartDate: AnyPublisher<String?, Never>
        let currentEndDate: AnyPublisher<String?, Never>
        let showCalendarIsStart: AnyPublisher<Bool, Never>
        let presentToPlaceVC: AnyPublisher<Void, Never>
        let enteredPlace: AnyPublisher<String, Never>
        let presentToParticipatingMemberVC: AnyPublisher<Void, Never>
        let selectedMembers: AnyPublisher<[ActivityMember], Never>
        let snackBarText: AnyPublisher<String, Never>
        let postActivity: AnyPublisher<Bool, Never>
        let popViewController: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
        
    private var activity: CreateActivity
    private let useCase: StudyActivitySettingUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(activity: CreateActivity, useCase: StudyActivitySettingUseCase) {
        self.activity = activity
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let placeSubject = CurrentValueSubject<String?, Never>(nil)
        let membersSubject = CurrentValueSubject<[ActivityMember], Never>([])
        let startDateSubject = CurrentValueSubject<String?, Never>(getCurrentFormattedDates().0)
        let endDateSubject = CurrentValueSubject<String?, Never>(getCurrentFormattedDates().1)
        
        let showCalendarIsStart = Publishers.Merge(
            input.didTapStartDateButton.map { true },
            input.didTapEndDateButton.map { false }
        )
            .eraseToAnyPublisher()
        
        let presentToPlaceVC = input.didTapPlaceButton
        let presentToMemberVC = input.didTapMemeberButton
        
        input.didEnterPlace
            .sink(receiveValue: placeSubject.send)
            .store(in: &cancellables)
        
        input.didSelectMembers
            .sink(receiveValue: membersSubject.send)
            .store(in: &cancellables)
        
        let enteredPlace = placeSubject
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        let selectedMembers = membersSubject
            .filter { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        let snackBarText = input.didTapPostButton
            .map { (self.activity.category, placeSubject.value, membersSubject.value) }
            .flatMap(useCase.getShowSnackBarText)
            .eraseToAnyPublisher()
        
        // snacBarText가 없을 때 활동 생성 요청
        let postActivity = snackBarText
            .filter { $0.isEmpty }
            .map { _ in (startDateSubject.value, endDateSubject.value, placeSubject.value, membersSubject.value) }
            .map(updateCreateActivity)
            .flatMap(useCase.postActivity)
            .filter { $0 }
            .eraseToAnyPublisher()
            
        
        return Output(
            currentCategory: Just(activity.category).eraseToAnyPublisher(),
            currentStartDate: startDateSubject.eraseToAnyPublisher(),
            currentEndDate: endDateSubject.eraseToAnyPublisher(),
            showCalendarIsStart: showCalendarIsStart,
            presentToPlaceVC: presentToPlaceVC,
            enteredPlace: enteredPlace,
            presentToParticipatingMemberVC: presentToMemberVC,
            selectedMembers: selectedMembers,
            snackBarText: snackBarText,
            postActivity: postActivity,
            popViewController: input.didTapBackButton
        )
    }
}

extension CreateActivitySettingViewModel {
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
    
    private func updateCreateActivity(startDate: String?, endDate: String?, place: String?, members: [ActivityMember]) -> CreateActivity {
        activity.startDate = startDate
        activity.endDate = endDate
        activity.location = place
        activity.participants = members.map { $0.id }
        return activity
    }
}
