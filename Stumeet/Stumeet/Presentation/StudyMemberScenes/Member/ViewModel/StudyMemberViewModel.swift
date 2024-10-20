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
        let viewWillAppearTrigger: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyMemberDataSource: AnyPublisher<[StudyMember], Never>
        let studyMemberCount: AnyPublisher<Int, Never>
        let isAdminChecked: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    private var studyMemberUseCase: StudyMemberUseCase
    private var checkAdminUseCase: CheckAdminUseCase
    private var studyId: Int
    private var studyMemberItemsSubject = CurrentValueSubject<[StudyMember], Never>([])
    private var isAdminSubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        studyMemberUseCase: StudyMemberUseCase,
        checkAdminUseCase: CheckAdminUseCase,
        studyId: Int
    ) {
        self.studyMemberUseCase = studyMemberUseCase
        self.checkAdminUseCase = checkAdminUseCase
        self.studyId = studyId
    }
    
    func transform(input: Input) -> Output {
        let studyMemberDataSource = studyMemberItemsSubject.eraseToAnyPublisher()
        let studyMemberCount = studyMemberItemsSubject
            .map { $0.count }
            .eraseToAnyPublisher()
        
        let isAdminChecked = isAdminSubject.eraseToAnyPublisher()
        
        input.viewWillAppearTrigger
            .flatMap { [weak self] in
                guard let self else { return Just<[StudyMember]>([])
                    .eraseToAnyPublisher()}
                return getMembers()
            }
            .sink { [weak self] stduyMember in
                guard let self else { return }
                studyMemberItemsSubject.send(stduyMember)
            }
            .store(in: &cancellables)
        
        input.viewWillAppearTrigger
            .flatMap { [weak self] in
                guard let self else { return Just<Bool>(false).eraseToAnyPublisher()}
                return checkAdminUseCase.execute(studyID: studyId)
            }
            .sink { [weak self] isAdmin in
                guard let self else { return }
                isAdminSubject.send(isAdmin)
            }
            .store(in: &cancellables)
        
        return Output(
            studyMemberDataSource: studyMemberDataSource,
            studyMemberCount: studyMemberCount,
            isAdminChecked: isAdminChecked
        )
    }
    
    // MARK: - Function
    private func getMembers() -> AnyPublisher<[StudyMember], Never> {
        studyMemberUseCase.getMembers(studyID: studyId)
    }

}
