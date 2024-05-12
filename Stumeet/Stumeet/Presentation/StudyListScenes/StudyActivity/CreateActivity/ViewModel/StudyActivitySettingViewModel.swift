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
        let didTapPostButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let showCalendarIsStart: AnyPublisher<Bool, Never>
        let presentToPlaceVC: AnyPublisher<Void, Never>
        let presentToParticipatingMemberVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    
    // MARK: - Init
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        let showCalendarIsStart = Publishers.Merge(
            input.didTapStartDateButton.map { true },
            input.didTapEndDateButton.map { false }
        )
            .eraseToAnyPublisher()
        let presentToPlaceVC = input.didTapPlaceButton
        let presentToMemberVC = input.didTapMemeberButton
        
        return Output(
            showCalendarIsStart: showCalendarIsStart,
            presentToPlaceVC: presentToPlaceVC,
            presentToParticipatingMemberVC: presentToMemberVC)
    }
}
