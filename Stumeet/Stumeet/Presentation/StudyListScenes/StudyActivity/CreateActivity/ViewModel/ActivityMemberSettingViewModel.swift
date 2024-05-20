// ActivityMemberSettingViewModel.swift

import Combine
import Foundation

final class ActivityMemberSettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectIndexPathPublisher: AnyPublisher<IndexPath, Never>
        let didTapAllSelectButton: AnyPublisher<Bool, Never>
        let searchTextPublisher: AnyPublisher<String?, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let members: AnyPublisher<[ActivityMemberSectionItem], Never>
        let isSelectedAll: AnyPublisher<Bool, Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: ActivityMemberSettingUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Subject
    
    private let memberSubject = CurrentValueSubject<[ActivityMemberSectionItem], Never>([])
    private let filteredMemberSubject = CurrentValueSubject<[ActivityMemberSectionItem], Never>([])
    
    // MARK: - Init
    
    init(useCase: ActivityMemberSettingUseCase) {
        self.useCase = useCase
        
        useCase.getMembers()
            .handleEvents(receiveOutput: filteredMemberSubject.send)
            .sink(receiveValue: memberSubject.send)
            .store(in: &cancellables)
    }
    
    func transform(input: Input) -> Output {
        
        let members = filteredMemberSubject.eraseToAnyPublisher()
        
        input.didSelectIndexPathPublisher
            .map { ($0, self.memberSubject.value, self.filteredMemberSubject.value) }
            .flatMap(useCase.toggleSelection)
            .sink { [weak self] updatedMembers, updatedFilteredMembers in
                self?.memberSubject.send(updatedMembers)
                self?.filteredMemberSubject.send(updatedFilteredMembers)
            }
            .store(in: &cancellables)
        
        input.searchTextPublisher
            .compactMap { $0 }
            .combineLatest(memberSubject)
            .flatMap(useCase.setFilterMembers)
            .sink(receiveValue: filteredMemberSubject.send)
            .store(in: &cancellables)
        
        let isSelectedAll = input.didTapAllSelectButton
            .map { (!$0, self.memberSubject.value) }
            .flatMap(useCase.setIsSelectedAll)
            .map { [weak self] members, isSelected in
                self?.memberSubject.send(members)
                return isSelected
            }
            .eraseToAnyPublisher()
        
        let isEnableCompleteButton = filteredMemberSubject
            .flatMap(useCase.setIsEnableCompleteButton)
            .eraseToAnyPublisher()

        return Output(
            members: members,
            isSelectedAll: isSelectedAll,
            isEnableCompleteButton: isEnableCompleteButton
        )
    }
}
