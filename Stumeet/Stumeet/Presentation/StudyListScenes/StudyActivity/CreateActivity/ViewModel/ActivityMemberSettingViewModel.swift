// ActivityMemberSettingViewModel.swift

import Combine
import Foundation

final class ActivityMemberSettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectIndexPathPublisher: AnyPublisher<IndexPath, Never>
        let didTapAllSelectButton: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let members: AnyPublisher<[ActivityMemberSectionItem], Never>
        let isSelectedAll: AnyPublisher<Bool, Never>
        let memberCount: AnyPublisher<Int, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: ActivityMemberSettingUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Subject
    
    private let memberSubject = CurrentValueSubject<[ActivityMemberSectionItem], Never>([])
    
    // MARK: - Init
    
    init(useCase: ActivityMemberSettingUseCase) {
        self.useCase = useCase
        
        useCase.getMembers()
            .sink(receiveValue: memberSubject.send)
            .store(in: &cancellables)
    }
    
    func transform(input: Input) -> Output {
        
        let members = memberSubject.eraseToAnyPublisher()
        
        let memberCount = members.map { $0.count }.eraseToAnyPublisher()
        
        input.didSelectIndexPathPublisher
            .map { ($0, self.memberSubject.value) }
            .flatMap(useCase.toggleSelection)
            .sink(receiveValue: memberSubject.send)
            .store(in: &cancellables)
        
        
        let isSelectedAll = input.didTapAllSelectButton
            .map { (!$0, self.memberSubject.value) }
            .flatMap(useCase.setIsSelectedAll)
            .handleEvents(receiveOutput: { members, _ in  self.memberSubject.send(members) })
            .map { $1 }
            .eraseToAnyPublisher()
        
        return Output(
            members: members,
            isSelectedAll: isSelectedAll,
            memberCount: memberCount
        )
    }
}
