//
//  HomeViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import Combine
import Foundation

final class HomeViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let didTapAlarmButton: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let presentToAlarmVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    private var alarmItemsSubject = CurrentValueSubject<[StudyMember], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
    ) {
    }
    
    func transform(input: Input) -> Output {
        let presentToAlarmVC = input.didTapAlarmButton
            .eraseToAnyPublisher()
       

        return Output(
            presentToAlarmVC: presentToAlarmVC
        )
    }
    
    // MARK: - Function
}
