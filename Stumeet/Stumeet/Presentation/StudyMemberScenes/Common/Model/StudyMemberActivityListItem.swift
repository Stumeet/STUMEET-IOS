//
//  StudyMemberActivityListItem.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/04.
//

import Foundation

struct StudyMemberActivityListItem: Hashable {
    
    let activity: Activity
    var id: Int { activity.id }
    var cellType: StudyMemberActivityListCellStyle
    var screenType: StudyMemberActivityListScreenType

    var type: ActivityCategory? {
        activity.tag
    }
    
    var displayTitle: String {
        activity.title
    }
    
    var displayStartTiem: String {
        activity.startTiem?.formattedDateHHmm() ?? "0000.00.00 00:00"
    }
    
    var displayEndTime: String {
        activity.endTime?.formattedDateHHmm() ?? "0000.00.00 00:00" + "까지"
    }
    
    var displayLocation: String {
        activity.place ?? "장소"
    }
    
    var displayState: ActivityState? {
        activity.status
    }
    
    enum StudyMemberActivityListCellStyle {
        case firstCell
        case normal
    }
    
    enum StudyMemberActivityListScreenType {
        case detail
        case achievement
    }
    
    internal init(
        activity: Activity,
        cellType: StudyMemberActivityListItem.StudyMemberActivityListCellStyle,
        screenType: StudyMemberActivityListItem.StudyMemberActivityListScreenType
    ) {
        self.activity = activity
        self.cellType = cellType
        self.screenType = screenType
    }
}
