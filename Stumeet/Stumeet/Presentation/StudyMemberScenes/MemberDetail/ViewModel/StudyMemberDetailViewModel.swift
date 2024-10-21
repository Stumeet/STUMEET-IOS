//
//  StudyMemberDetailViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/02.
//

import Combine
import Foundation

final class StudyMemberDetailViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let viewWillAppearTrigger: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let studyMemberHeaderItem: AnyPublisher<StudyMemberDetailInfoHeaderItem, Never>
        let showMoreButtonState: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    private var studyId: Int
    private var studyMemberId: Int
    private var fetchStudyMemberDetailUseCase: FetchStudyMemberDetailUseCase
    private var checkAdminUseCase: CheckAdminUseCase
    private var studyMemberHeaderItemSubject = CurrentValueSubject<StudyMemberDetailInfoHeaderItem?, Never>(nil)
    private var isStudyMemberAdminSubject = CurrentValueSubject<Bool, Never>(false)
    private var isCurrentUserAdminSubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchStudyMemberDetailUseCase: FetchStudyMemberDetailUseCase,
        checkAdminUseCase: CheckAdminUseCase,
        studyId: Int,
        studyMemberId: Int
    ) {
        self.fetchStudyMemberDetailUseCase = fetchStudyMemberDetailUseCase
        self.checkAdminUseCase = checkAdminUseCase
        self.studyId = studyId
        self.studyMemberId = studyMemberId
    }
    
    func transform(input: Input) -> Output {
        let studyMemberHeaderItem = studyMemberHeaderItemSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let showMoreButtonState = Publishers
            .CombineLatest(isStudyMemberAdminSubject, isCurrentUserAdminSubject)
            .map { isStudyMemberAdmin, isCurrentUserAdmin in
                return isCurrentUserAdmin && !isStudyMemberAdmin
            }
            .eraseToAnyPublisher()

        input.viewWillAppearTrigger
            .flatMap { [weak self] in
                guard let self else { return Empty<StudyMember, Never>().eraseToAnyPublisher() }
                return fetchStudyMemberDetailUseCase.execute(
                    studyID: self.studyId,
                    memberID: self.studyMemberId
                )
            }
            .sink { [weak self] memberItem in
                guard let self else { return }
                studyMemberHeaderItemSubject.send(StudyMemberDetailInfoHeaderItem(member: memberItem))
                isStudyMemberAdminSubject.send(memberItem.isAdmin)
            }
            .store(in: &cancellables)
        
        input.viewWillAppearTrigger
            .flatMap { [weak self] in
                guard let self else { return Empty<Bool, Never>().eraseToAnyPublisher()}
                return checkAdminUseCase.execute(studyID: studyId)
            }
            .sink { [weak self] isAdmin in
                guard let self else { return }
                isCurrentUserAdminSubject.send(isAdmin)
            }
            .store(in: &cancellables)
        
        return Output(
            studyMemberHeaderItem: studyMemberHeaderItem,
            showMoreButtonState: showMoreButtonState
        )
    }
    
    // MARK: - Function
}
