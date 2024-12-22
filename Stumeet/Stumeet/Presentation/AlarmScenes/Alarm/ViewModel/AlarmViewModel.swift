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
//        let didSelectMemberRow: AnyPublisher<IndexPath, Never>
    }

    // MARK: - Output
    struct Output {
        let alarmDataSource: AnyPublisher<[AlarmListItem], Never>
    }
    
    // MARK: - Properties
    private var alarmItemsSubject = CurrentValueSubject<[AlarmListItem], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
    ) {
    }
    
    func transform(input: Input) -> Output {
        let alarmDataSource = alarmItemsSubject.eraseToAnyPublisher()
       
        // TODO: API 연동 시 수정
        input.loadData
            .sink { [weak self] in
                guard let self else { return }
                let list = [
                    AlarmListItem(id: 0),
                    AlarmListItem(id: 1),
                    AlarmListItem(id: 2),
                    AlarmListItem(id: 3),
                    AlarmListItem(id: 4),
                    AlarmListItem(id: 5),
                    AlarmListItem(id: 6),
                    AlarmListItem(id: 7),
                    AlarmListItem(id: 8),
                    AlarmListItem(id: 9),
                    AlarmListItem(id: 10),
                    AlarmListItem(id: 11),
                    AlarmListItem(id: 12)
                ]
                alarmItemsSubject.send(list)
            }
            .store(in: &cancellables)
        

        return Output(
            alarmDataSource: alarmDataSource
        )
    }
    
    // MARK: - Function
}
