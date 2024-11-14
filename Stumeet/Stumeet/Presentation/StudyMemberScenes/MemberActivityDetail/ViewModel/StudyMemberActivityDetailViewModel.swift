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
    }

    // MARK: - Output
    struct Output {
        let studyMemberActivityDataSource: AnyPublisher<[StudyMemberMeetingStateListItem], Never>
        let activityHeaderItem: AnyPublisher<StudyMemberActivityViewItem?, Never>
    }
    
    // MARK: - UseCase
    private var fetchActiveStudyMembersUseCase: FetchActiveStudyMembersUseCase
    private var detailStudyActivityUseCase: DetailStudyActivityUseCase
    
    // MARK: - Properties
    private var studyID: Int
    private var activityID: Int
    
    private var studyMemberActivityItemsSubject = CurrentValueSubject<[StudyMemberMeetingStateListItem], Never>([])
    private var activityItemSubject = CurrentValueSubject<StudyMemberActivityViewItem?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchActiveStudyMembersUseCase: FetchActiveStudyMembersUseCase,
        detailStudyActivityUseCase: DetailStudyActivityUseCase,
        studyID: Int,
        activityID: Int
    ) {
        self.fetchActiveStudyMembersUseCase = fetchActiveStudyMembersUseCase
        self.detailStudyActivityUseCase = detailStudyActivityUseCase
        self.studyID = studyID
        self.activityID = activityID
    }
    
    func transform(input: Input) -> Output {
        
        let studyMemberActivityDataSource = studyMemberActivityItemsSubject.eraseToAnyPublisher()
        let activityItem = activityItemSubject.eraseToAnyPublisher()
        
        
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
            activityHeaderItem: activityItem
        )
    }
    
    // MARK: - Function
    private func convertToStudyMemberActivityItems(
        from detailActivityListItem: [DetailActivityMember]
    ) -> [StudyMemberMeetingStateListItem] {
        return detailActivityListItem.map {
            StudyMemberMeetingStateListItem(detailActivityMember: $0)
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
