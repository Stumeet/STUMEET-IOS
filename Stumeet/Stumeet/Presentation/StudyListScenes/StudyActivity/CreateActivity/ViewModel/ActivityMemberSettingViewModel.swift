// ActivityMemberSettingViewModel.swift

import Combine
import Foundation

final class ActivityMemberSettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectIndexPathPublisher: AnyPublisher<IndexPath, Never>
        let didTapAllSelectButton: AnyPublisher<Bool, Never>
        let searchTextPublisher: AnyPublisher<String?, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let members: AnyPublisher<[ActivityMemberSectionItem], Never>
        let isSelectedAll: AnyPublisher<Bool, Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completeMember: AnyPublisher<[ActivityMember], Never>
    }
    
    // MARK: - Properties
    
    private let useCase: ActivityMemberSettingUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(useCase: ActivityMemberSettingUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        
        let memberSubject = CurrentValueSubject<[ActivityMemberSectionItem], Never>([])
        let filteredMemberSubject = CurrentValueSubject<[ActivityMemberSectionItem], Never>([])
        
        let members = filteredMemberSubject.eraseToAnyPublisher()
        
        useCase.getMembers()
            .handleEvents(receiveOutput: filteredMemberSubject.send)
            .sink(receiveValue: memberSubject.send)
            .store(in: &cancellables)
        
        
        input.didSelectIndexPathPublisher
            .map { ($0, memberSubject.value, filteredMemberSubject.value) }
            .flatMap(useCase.toggleSelection)
            .sink { updatedMembers, updatedFilteredMembers in
                memberSubject.send(updatedMembers)
                filteredMemberSubject.send(updatedFilteredMembers)
            }
            .store(in: &cancellables)
        
        input.searchTextPublisher
            .compactMap { $0 }
            .combineLatest(memberSubject)
            .flatMap(useCase.setFilterMembers)
            .sink(receiveValue: filteredMemberSubject.send)
            .store(in: &cancellables)
        
        let isSelectedAll = input.didTapAllSelectButton
            .map { (!$0, filteredMemberSubject.value) }
            .flatMap(useCase.setIsSelectedAll)
            .map { members, isSelected in
                filteredMemberSubject.send(members)
                return isSelected
            }
            .eraseToAnyPublisher()
        
        let isEnableCompleteButton = filteredMemberSubject
            .flatMap(useCase.setIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let completeMember = input.didTapCompleteButton
            .map { _ in filteredMemberSubject.value }
            .flatMap(useCase.completeMembers)
            .eraseToAnyPublisher()

        return Output(
            members: members,
            isSelectedAll: isSelectedAll,
            isEnableCompleteButton: isEnableCompleteButton,
            completeMember: completeMember
        )
    }
}
