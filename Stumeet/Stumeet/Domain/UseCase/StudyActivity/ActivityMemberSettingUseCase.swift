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
    func completeMembers(members: [ActivityMemberSectionItem]) -> AnyPublisher<[String], Never>
}

final class DefaultActivityMemberSettingUseCase: ActivityMemberSettingUseCase {
    private let repository: ActivityMemberSettingRepository
    
    init(repository: ActivityMemberSettingRepository) {
        self.repository = repository
    }
    
    func getMembers() -> AnyPublisher<[ActivityMemberSectionItem], Never> {
        return repository.fetchMembers()
            .map { $0.map { ActivityMemberSectionItem.memberCell($0) } }
            .eraseToAnyPublisher()
    }
    
    func toggleSelection(
        indexPath: IndexPath,
        members: [ActivityMemberSectionItem],
        filterMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem]), Never> {
        
        guard case .memberCell(let item) = filterMembers[indexPath.row] else {
            return Empty().eraseToAnyPublisher()
        }
        
        var toggledMember = item
        toggledMember.isSelected.toggle()
        
        let toggledItem = ActivityMemberSectionItem.memberCell(toggledMember)
        
        let allMembers = members.map { member -> ActivityMemberSectionItem in
            if case .memberCell(let item) = member, item.id == member.id {
                return toggledItem
            }
            return member
        }
        
        var filteredMembers = filterMembers
        filteredMembers[indexPath.row] = toggledItem
        
        return Just((allMembers, filteredMembers)).eraseToAnyPublisher()
    }
    

    func setIsSelectedAll(isSelected: Bool, members: [ActivityMemberSectionItem]) -> AnyPublisher<([ActivityMemberSectionItem], Bool), Never> {
        let updatedMembers = members.map { member -> ActivityMemberSectionItem in
            switch member {
            case .memberCell(let item):
                var updatedItem = item
                updatedItem.isSelected = isSelected
                return .memberCell(updatedItem)
            }
        }
        return Just((updatedMembers, isSelected)).eraseToAnyPublisher()
    }
    
    func setFilterMembers(text: String, members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMemberSectionItem], Never> {
        let filteredMembers = text.isEmpty ? members : members.filter { member in
            if case .memberCell(let item) = member {
                return item.name.contains(text)
            }
            return false
        }
        return Just(filteredMembers).eraseToAnyPublisher()
    }
    
    func setIsEnableCompleteButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never> {
        let hasSelected = members.contains { member in
            if case .memberCell(let item) = member {
                return item.isSelected
            }
            return false
        }
        return Just(hasSelected).eraseToAnyPublisher()
    }
    
    func completeMembers(members: [ActivityMemberSectionItem]) -> AnyPublisher<[String], Never> {
        let selectedMembers = members.filter { member in
            if case .memberCell(let item) = member {
                return item.isSelected
            }
            return false
        }
            .map { member in
                if case .memberCell(let item) = member {
                    return item.name
                }
                return ""
            }
        
        return Just(selectedMembers).eraseToAnyPublisher()
    }
}
