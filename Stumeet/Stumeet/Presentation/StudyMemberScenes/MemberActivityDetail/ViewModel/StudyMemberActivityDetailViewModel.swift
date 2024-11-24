//
//  StudyMemberActivityDetailViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/14.
//

import Combine
import Foundation

final class StudyMemberActivityDetailViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let loadDataTrigger: AnyPublisher<Void, Never>
        let didTapActivityState: AnyPublisher<StudyMemberMeetingStateListItem, Never>
    }

    // MARK: - Output
    struct Output {
        let studyMemberActivityDataSource: AnyPublisher<[StudyMemberMeetingStateListItem], Never>
        let activityHeaderItem: AnyPublisher<StudyMemberActivityViewItem?, Never>
        let naviTitleText: AnyPublisher<String, Never>
        let updateActivityStatusCompleted: AnyPublisher<Bool, Never>
    }
    
    // MARK: - UseCase
    private var fetchActiveStudyMembersUseCase: FetchActiveStudyMembersUseCase
    private var detailStudyActivityUseCase: DetailStudyActivityUseCase
    private var updateMemberStatusUseCase: UpdateMemberStatusUseCase
    
    // MARK: - Properties
    private var studyID: Int
    private var activityID: Int
    private var category: ActivityCategory
    
    private var studyMemberActivityItemsSubject = CurrentValueSubject<[StudyMemberMeetingStateListItem], Never>([])
    private var activityItemSubject = CurrentValueSubject<StudyMemberActivityViewItem?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchActiveStudyMembersUseCase: FetchActiveStudyMembersUseCase,
        detailStudyActivityUseCase: DetailStudyActivityUseCase,
        updateMemberStatusUseCase: UpdateMemberStatusUseCase,
        studyID: Int,
        activityID: Int,
        category: ActivityCategory
    ) {
        self.fetchActiveStudyMembersUseCase = fetchActiveStudyMembersUseCase
        self.detailStudyActivityUseCase = detailStudyActivityUseCase
        self.updateMemberStatusUseCase = updateMemberStatusUseCase
        self.studyID = studyID
        self.activityID = activityID
        self.category = category
    }
    
    func transform(input: Input) -> Output {
        
        let studyMemberActivityDataSource = studyMemberActivityItemsSubject.eraseToAnyPublisher()
        let activityItem = activityItemSubject.eraseToAnyPublisher()
        let naviTitleText = input.loadDataTrigger
            .map { [weak self] in
                guard let title = self?.category.title else { return "상세" }
                return "\(title) 상세"
            }.eraseToAnyPublisher()
        
        let updateActivityStatusCompleted = input.didTapActivityState
            .flatMap { [weak self] activityState in
                guard let self,
                      let participantID = activityState.id
                else { return Empty<Bool, Never>().eraseToAnyPublisher()}
                return updateMemberStatusUseCase.execute(
                    studyID: studyID,
                    activityID: activityID,
                    participantID: participantID,
                    status: activityState.activityState.requestValue
                )
            }.eraseToAnyPublisher()
        
        
        input.loadDataTrigger
            .flatMap { [weak self] in
                guard let self else { return Empty<[DetailActivityMember], Never>().eraseToAnyPublisher()}
                return fetchActiveStudyMembersUseCase.execute(
                    studyID: studyID,
                    activityID: activityID
                )
            }
            .map(convertToStudyMemberActivityItems(from:))
            .sink { [weak self] studyMemberActivityList in
                guard let self else { return }
                studyMemberActivityItemsSubject.send(studyMemberActivityList)
            }
            .store(in: &cancellables)
        
        input.loadDataTrigger
            .flatMap { [weak self] in
                guard let self else { return Empty<DetailStudyActivity, Never>().eraseToAnyPublisher()}
                return detailStudyActivityUseCase.getDetailActivityItem(
                    studyID: studyID,
                    activityID: activityID
                )
            }
            .compactMap(convertToStudyMemberActivityViewItem(from:))
            .sink { [weak self] activityViewItem in
                guard let self else { return }
                activityItemSubject.send(activityViewItem)
            }
            .store(in: &cancellables)
        
        return Output(
            studyMemberActivityDataSource: studyMemberActivityDataSource,
            activityHeaderItem: activityItem,
            naviTitleText: naviTitleText,
            updateActivityStatusCompleted: updateActivityStatusCompleted
        )
    }
    
    // MARK: - Function
    private func convertToStudyMemberActivityItems(
        from detailActivityListItem: [DetailActivityMember]
    ) -> [StudyMemberMeetingStateListItem] {
        return detailActivityListItem.map {
            StudyMemberMeetingStateListItem(detailActivityMember: $0, category: category)
        }
    }
    
    private func convertToStudyMemberActivityViewItem(
        from detailStudyActivity: DetailStudyActivity
    ) -> StudyMemberActivityViewItem? {
        guard let topItem = detailStudyActivity.top,
              let bottomItem = detailStudyActivity.bottom
        else { return nil }
        let activity = Activity(
            id: topItem.id,
            tag: topItem.category,
            title: topItem.title,
            startTiem: bottomItem.startDate,
            endTime: bottomItem.endDate,
            place: bottomItem.place
        )
        return StudyMemberActivityViewItem(activity: activity)
    }
}
