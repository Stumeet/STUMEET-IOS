//
//  AlarmViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import Combine
import Foundation

final class AlarmViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadData: AnyPublisher<Void, Never>
        let didSelectMemberRow: AnyPublisher<IndexPath, Never>
    }

    // MARK: - Output
    struct Output {
        let alarmDataSource: AnyPublisher<[StudyMember], Never>
    }
    
    // MARK: - Properties
    private var alarmItemsSubject = CurrentValueSubject<[StudyMember], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
    ) {
    }
    
    func transform(input: Input) -> Output {
        let alarmDataSource = alarmItemsSubject.eraseToAnyPublisher()
       

        return Output(
            alarmDataSource: alarmDataSource
        )
    }
    
    // MARK: - Function
}
