//
//  StudyMemberViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/25.
//

import Combine
import Foundation

final class StudyMemberViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadStudyMemberData: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyMemberDataSource: AnyPublisher<[StudyMember], Never>
    }
    
    // MARK: - Properties
    private var useCase: StudyMemberUseCase
    private var studyId: Int
    private var studyMemberItemsSubject = CurrentValueSubject<[StudyMember], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        useCase: StudyMemberUseCase,
        studyId: Int
    ) {
        self.useCase = useCase
        self.studyId = studyId
    }
    
    func transform(input: Input) -> Output {
        let studyMemberDataSource = studyMemberItemsSubject.eraseToAnyPublisher()
        
        input.loadStudyMemberData
            .flatMap(getMembers)
            .sink(receiveValue: studyMemberItemsSubject.send)
            .store(in: &cancellables)
    
        return Output(
            studyMemberDataSource: studyMemberDataSource
        )
    }
    
    // MARK: - Function
    private func getMembers() -> AnyPublisher<[StudyMember], Never> {
        useCase.getMembers(studyID: studyId)
    }

}

