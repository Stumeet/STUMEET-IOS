// ActivityMemberSettingUseCase.swift

import Combine
import Foundation

protocol ActivityMemberSettingUseCase {
    func getMembers() -> AnyPublisher<[ActivityMemberSectionItem], Never>
    func toggleSelection(
        indexPath: IndexPath,
        members: [ActivityMemberSectionItem],
        filterMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem]), Never>
    func setIsSelectedAll(isSelected: Bool, members: [ActivityMemberSectionItem]) -> AnyPublisher<([ActivityMemberSectionItem], Bool), Never>
    func setFilterMembers(text: String, members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMemberSectionItem], Never>
    func setIsEnableCompleteButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never>
    
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
    
    func toggleSelection(
        indexPath: IndexPath,
        members: [ActivityMemberSectionItem],
        filterMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem]), Never> {
        
        guard case .memberCell(let name, let isSelected) = filterMembers[indexPath.row] else {
            return Empty().eraseToAnyPublisher()
        }
        
        let toggledMember = ActivityMemberSectionItem.memberCell(name, !isSelected)
        
        let allMembers = members.map { member -> ActivityMemberSectionItem in
            if case .memberCell(let memberName, _) = member, memberName == name {
                return toggledMember
            }
            return member
        }
        
        var filteredMembers = filterMembers
        filteredMembers[indexPath.row] = toggledMember
        
        return Just((allMembers, filteredMembers)).eraseToAnyPublisher()
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
    
    func setFilterMembers(text: String, members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMemberSectionItem], Never> {
        let filteredMembers = text.isEmpty ? members : members.filter {
            if case .memberCell(let name, _) = $0 {
                return name.contains(text)
            }
            return false
        }
        return Just(filteredMembers).eraseToAnyPublisher()
    }
    
    func setIsEnableCompleteButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never> {
        let hasSelected = members.contains { member in
            if case .memberCell(_, let isSelected) = member {
                return isSelected
            }
            return false
        }
        return Just(hasSelected).eraseToAnyPublisher()
    }
}
