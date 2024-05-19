// ActivityMemberSettingUseCase.swift

import Combine
import Foundation

protocol ActivityMemberSettingUseCase {
    func getMembers() -> AnyPublisher<[ActivityMemberSectionItem], Never>
    func toggleSelection(at indexPath: IndexPath, members: [ActivityMemberSectionItem]) -> AnyPublisher<([ActivityMemberSectionItem]), Never>
    func setIsSelectedAll(isSelected: Bool, members: [ActivityMemberSectionItem]) -> AnyPublisher<([ActivityMemberSectionItem], Bool), Never>
}

final class DefaultActivityMemberSettingUseCase: ActivityMemberSettingUseCase {
    private let repository: ActivityMemberSettingRepository
    
    init(repository: ActivityMemberSettingRepository) {
        self.repository = repository
    }
    
    func getMembers() -> AnyPublisher<[ActivityMemberSectionItem], Never> {
        return repository.fetchMembers()
            .map { $0.map { ActivityMemberSectionItem.memberCell($0, false)} }
            .eraseToAnyPublisher()
    }
    
    func toggleSelection(at indexPath: IndexPath, members: [ActivityMemberSectionItem]) -> AnyPublisher<([ActivityMemberSectionItem]), Never> {
        var toggleMembers = members
        if case .memberCell(let name, let isSelected) = toggleMembers[indexPath.row] {
            toggleMembers[indexPath.row] = .memberCell(name, !isSelected)
            return Just(toggleMembers).eraseToAnyPublisher()
        }
        return Empty().eraseToAnyPublisher()
    }
    
    func setIsSelectedAll(isSelected: Bool, members: [ActivityMemberSectionItem]) -> AnyPublisher<([ActivityMemberSectionItem], Bool), Never> {
        let updatedMembers = members.map { member -> ActivityMemberSectionItem in
            switch member {
            case .memberCell(let name, _):
                return .memberCell(name, isSelected)
            }
        }
        return Just((updatedMembers, isSelected)).eraseToAnyPublisher()
    }
}
