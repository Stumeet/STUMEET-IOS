// ActivityMemberSettingViewModel.swift

import Combine
import Foundation

final class ActivityMemberSettingViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectIndexPathPublisher: AnyPublisher<IndexPath, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let members: AnyPublisher<[String], Never>
        let selectionState: AnyPublisher<(IndexPath, Bool), Never>
    }
    
    // MARK: - Properties
    
    private let useCase: ActivityMemberSettingUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Subject
    
    private let selectedIndexPathsSubject = CurrentValueSubject<Set<IndexPath>, Never>([])
    
    // MARK: - Init
    
    init(useCase: ActivityMemberSettingUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let members = useCase.getMembers()
        
        let selectionState = input.didSelectIndexPathPublisher
            .map { (self.selectedIndexPathsSubject.value, $0) }
            .map(useCase.toggleSelection)
            .handleEvents(receiveOutput: { [weak self] indexPaths, _, _ in
                self?.selectedIndexPathsSubject.send(indexPaths)
            })
            .map { ($1, $2) }
            .eraseToAnyPublisher()
        
        return Output(
            members: members,
            selectionState: selectionState
        )
    }
}
