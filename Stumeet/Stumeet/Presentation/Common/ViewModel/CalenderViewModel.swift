//
//  CalenderViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/20.
//

import Foundation
import Combine

protocol CalenderViewModel: ViewModelType, ObservableObject {
    // MARK: - Action
    var loadData: PassthroughSubject<Void, Never> { get }

    // MARK: - Properties
    var currentMonthString: String { get }
    var scheduleList: [ScheduleItem] { get }
    var scheduleDetailList: [ScheduleItem] { get }
    var isLeftButtonDisable: Bool { get }
    var isRightButtonDisable: Bool { get }
    
    // MARK: - Methods
    func changeMonth(by value: Int)
    func setSelectedDate(_ date: Date)
    
    /// 날짜 범위 확인
    func checkDateContainedIn(_ dateToCheck: Date, start startDateString: String?, end endDateString: String?) -> Bool
    /// 특정 해당 날짜
    func getDate(for day: Int) -> Date
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date
    /// 해당 월에 존재하는 일자 수
    func numberOfDays() -> Int
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth() -> Int
    /// 해당 일에 활동 여부 확인
    func checkEventForSelectedDate(_ selectedDate: Date) -> Bool
    /// 선택된 날짜가 맞는지 확인
    func checkIfSelectedDate(_ date: Date) -> Bool
}
