// ActivityMemberSettingUseCase.swift

import Combine
import Foundation

protocol ActivityMemberSettingUseCase {
    func getMembers(members: [ActivityMember]) -> AnyPublisher<[ActivityMemberSectionItem], Never>
    func toggleSelection(
        indexPath: IndexPath,
        members: [ActivityMemberSectionItem],
        filterMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem]), Never>
    func getIsSelectedEntireMember(
        isSelected: Bool,
        members: [ActivityMemberSectionItem],
        filteredMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem], Bool), Never>
    func getIsSelectedAllButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never>
    func getFilterMembers(text: String, members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMemberSectionItem], Never>
    func getIsEnableCompleteButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never>
    func completeMembers(members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMember], Never>
}

final class DefaultActivityMemberSettingUseCase: ActivityMemberSettingUseCase {
    private let repository: ActivityMemberSettingRepository
    
    init(repository: ActivityMemberSettingRepository) {
        self.repository = repository
    }
    
    func getMembers(members: [ActivityMember]) -> AnyPublisher<[ActivityMemberSectionItem], Never> {
        return repository.fetchMembers()
            .map { fetchedMembers in
                fetchedMembers.map { fetchedMember in
                    members.first(where: { $0.id == fetchedMember.id }).map {
                        ActivityMemberSectionItem.memberCell($0)
                    } ?? ActivityMemberSectionItem.memberCell(fetchedMember)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func toggleSelection(
        indexPath: IndexPath,
        members: [ActivityMemberSectionItem],
        filterMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem]), Never> {
        
        guard case .memberCell(let toggledItem) = filterMembers[indexPath.row] else {
            return Empty().eraseToAnyPublisher()
        }
        
        var toggledMember = toggledItem
        toggledMember.isSelected.toggle()
        
        let toggledSectionItem = ActivityMemberSectionItem.memberCell(toggledMember)
        
        let allMembers = members.map { member -> ActivityMemberSectionItem in
            if member.item.id == toggledItem.id {
                return toggledSectionItem
            } else {
                return member
            }
        }
        
        var filteredMembers = filterMembers
        filteredMembers[indexPath.row] = toggledSectionItem
        
        return Just((allMembers, filteredMembers)).eraseToAnyPublisher()
    }
    

    func getIsSelectedEntireMember(
        isSelected: Bool,
        members: [ActivityMemberSectionItem],
        filteredMembers: [ActivityMemberSectionItem]
    ) -> AnyPublisher<([ActivityMemberSectionItem], [ActivityMemberSectionItem], Bool), Never> {
        let selectedFilteredMembers = filteredMembers.map { member -> ActivityMemberSectionItem in
            var updatedItem = member.item
            updatedItem.isSelected = isSelected
            return .memberCell(updatedItem)
        }
        
        let updatedMembers = members.map { member -> ActivityMemberSectionItem in
            if filteredMembers.contains(where: { filteredMember in
                return filteredMember.item.id == member.item.id
            }) {
                var updatedItem = member.item
                updatedItem.isSelected = isSelected
                return .memberCell(updatedItem)
            }
            return member
        }
        return Just((updatedMembers, selectedFilteredMembers, isSelected)).eraseToAnyPublisher()
    }
    
    func getIsSelectedAllButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never> {
        let isSelected =  members.allSatisfy { $0.item.isSelected == true } && !members.isEmpty
        return Just(isSelected).eraseToAnyPublisher()
    }
    
    func getFilterMembers(text: String, members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMemberSectionItem], Never> {
        let filteredMembers = text.isEmpty ? members : members.filter { $0.item.name.contains(text) }
        return Just(filteredMembers).eraseToAnyPublisher()
    }
    
    func getIsEnableCompleteButton(members: [ActivityMemberSectionItem]) -> AnyPublisher<Bool, Never> {
        let hasSelected = members.contains { $0.item.isSelected }
        return Just(hasSelected).eraseToAnyPublisher()
    }
    
    func completeMembers(members: [ActivityMemberSectionItem]) -> AnyPublisher<[ActivityMember], Never> {
        let selectedMembers = members
            .filter { $0.item.isSelected }
            .map { $0.item }
        
        return Just(selectedMembers).eraseToAnyPublisher()
    }
}
