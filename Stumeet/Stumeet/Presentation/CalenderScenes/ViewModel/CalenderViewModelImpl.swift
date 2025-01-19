//
//  CalenderViewModelImpl.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/19.
//

import Foundation
import Combine
import Algorithms

final class CalenderViewModelImpl: CalenderViewModel {
    // MARK: - Input
    struct Input {
        let loadTitle: AnyPublisher<Void, Never>
    }
    
    // MARK: - Action
    let loadData = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Properties
    private var selectedDate: Date = Date()
    private var currentMonth: Date = Date()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var isLeftButtonDisable: Bool = false
    private(set) var isRightButtonDisable: Bool = false
    @Published private(set) var currentMonthString: String = ""
    @Published private(set) var scheduleList: [ScheduleItem] = []
    @Published private(set) var scheduleDetailList: [ScheduleItem] = []
    
    // MARK: - Init
    init() {
        self.currentMonthString = currentMonth.dateString(format: "yyyy년 MM월")
        
        loadData
            .map { [weak self] () -> [ScheduleItem] in
                guard let self else { return [] }
                // TODO: - 테스트 데이트
                return updateActivityPageData(
                    receiveValue: ActivityPage(
                        pageInfo: .init(
                            totalPages: 2,
                            totalElements: 30,
                            currentPage: 0,
                            pageSize: 20
                        ),
                        activitys: [
                            Activity(id: 0, title: "타이틀 테스트"),
                            Activity(id: 1, title: "타이틀 테스트"),
                            Activity(id: 2, title: "타이틀 테스트"),
                            Activity(id: 3, title: "타이틀 테스트"),
                            Activity(id: 4, title: "타이틀 테스트"),
                            Activity(id: 5, title: "타이틀 테스트"),
                            Activity(id: 6, title: "타이틀 테스트"),
                            Activity(id: 7, title: "타이틀 테스트"),
                            Activity(id: 8, title: "타이틀 테스트"),
                            Activity(id: 9, title: "타이틀 테스트"),
                            Activity(id: 10, title: "타이틀 테스트")
                        ]
                    )
                )
            }
            .sink { [weak self] listItem in
                guard let self else { return }
                scheduleList = listItem
                setSelectedDate(selectedDate)
            }
            .store(in: &cancellables)
    }
    
    func transform(input: Input) -> Output {

        
        return Output(
            
        )
    }
    
    // MARK: - Function
    private func checkThisMonth() {
        let calendar = Calendar.korean
        
        let targetDate = calendar.dateComponents([.year, .month], from: currentMonth)
        let currentDate = calendar.dateComponents([.year, .month], from: Date())
        
        if targetDate == currentDate {
            setSelectedDate(Date())
        } else {
            setSelectedDate(startOfMonth())
        }
    }
    
    private func updateActivityPageData(receiveValue: ActivityPage) -> [ScheduleItem] {
        return convertToScheduleItem(from: receiveValue)
    }
    
    private func convertToScheduleItem(
        from activityPage: ActivityPage
    ) -> [ScheduleItem] {
        return activityPage.activitys.map {
            ScheduleItem(
                activity: $0
            )
        }
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            currentMonthString = newMonth.dateString(format: "yyyy년 MM월")
        }

        checkThisMonth()
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        // FIXME: - 테스트 로직
        scheduleDetailList = scheduleList
//        scheduleDetailList = scheduleList.filter {
//            checkDateContainedIn(
//                date,
//                start: $0.activity.startTiem,
//                end: $0.activity.endTime
//            )
//        }
    }
    
    /// 날짜 범위 확인
    func checkDateContainedIn(_ dateToCheck: Date, start startDateString: String?, end endDateString: String?) -> Bool {
        guard let startDateString, let endDateString else {
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString),
              let strippedStartDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: startDate)),
              let strippedEndDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: endDate)) else {
            return false
        }
        
        let strippedDateToCheck = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: dateToCheck))!

        // 시작일과 종료일 사이에 있는지 확인
        return strippedDateToCheck >= strippedStartDate && strippedDateToCheck <= strippedEndDate
    }

    /// 특정 해당 날짜
    func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 해당 일에 활동 여부 확인
    func checkEventForSelectedDate(_ selectedDate: Date) -> Bool {
        return scheduleList.contains {
            checkDateContainedIn(selectedDate, start: $0.activity.startTiem, end: $0.activity.endTime)
        }
    }
    
    /// 선택된 날짜가 맞는지 확인
    func checkIfSelectedDate(_ date: Date) -> Bool {
        return date.dateString(format: "yyyy-MM-dd") == selectedDate.dateString(format: "yyyy-MM-dd")
    }
}
