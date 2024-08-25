//
//  SelectStudyRepeatViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 8/10/24.
//

import Combine
import Foundation

final class SelectStudyRepeatViewModel: ViewModelType {
    
    enum DragState {
        case began
        case changed
        case ended
        case cancelled
    }
    
    struct DragInfo {
        let state: DragState
        let translationY: CGFloat
        let velocityY: CGFloat
        let bottomSheetViewHeight: CGFloat
    }
    
    // MARK: - Input
    
    struct Input {
        let didTapBackgroundButton: AnyPublisher<Void, Never>
        let didDragEvent: AnyPublisher<DragInfo, Never>
        let didTapDailyButton: AnyPublisher<Void, Never>
        let didTapWeeklyButton: AnyPublisher<Void, Never>
        let didTapMonthlyButton: AnyPublisher<Void, Never>
        let didSelectedMontlhyDay: AnyPublisher<IndexPath, Never>
        let didSelectedWeeklyDay: AnyPublisher<Int, Never>
        let didTapCompleteButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let dismiss: AnyPublisher<Void, Never>
        let adjustHeight: AnyPublisher<CGFloat, Never>
        let isRestoreBottomSheetView: AnyPublisher<(Bool, CGFloat), Never>
        let selectedRepeatType: AnyPublisher<StudyRepeatType, Never>
        let monthlyDays: AnyPublisher<[SelectStudyRepeatSectionItem], Never>
        let selectedWeeklyDays: AnyPublisher<[Bool], Never>
        let isEnableCompleteButton: AnyPublisher<Bool, Never>
        let completeDays: AnyPublisher<StudyRepeatType, Never>
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: SelectStudyRepeatUseCase
    
    // MARK: - Init
    
    init(useCase: SelectStudyRepeatUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let monthlyDaysSubject = CurrentValueSubject<[CalendarDate], Never>([])
        let weeklyDaysSubject = CurrentValueSubject<[Bool], Never>([Bool](repeating: false, count: 7))
        let selectedRepeatTypeSubject = CurrentValueSubject<StudyRepeatType?, Never>(nil)
        
        let dismiss = input.didTapBackgroundButton
        
        let adjustHeight = input.didDragEvent
            .filter { $0.state == .changed }
            .map { ($0.bottomSheetViewHeight, selectedRepeatTypeSubject.value?.height, $0.translationY)}
            .flatMap(useCase.setAdjustHeight)
            .eraseToAnyPublisher()
        
        let isRestoreBottomSheetView = input.didDragEvent
            .filter { $0.state == .ended || $0.state == .cancelled }
            .map { ($0.velocityY, $0.bottomSheetViewHeight, selectedRepeatTypeSubject.value?.height) }
            .flatMap(useCase.setIsRestoreBottomSheetView)
            .eraseToAnyPublisher()
        
        input.didTapMonthlyButton
            .map { monthlyDaysSubject.value }
            .flatMap(useCase.getMonthlyDays)
            .sink(receiveValue: monthlyDaysSubject.send)
            .store(in: &cancellables)
        
        input.didSelectedMontlhyDay
            .map { ($0, monthlyDaysSubject.value) }
            .flatMap(useCase.getSelectedMonthlyDays)
            .sink(receiveValue: monthlyDaysSubject.send)
            .store(in: &cancellables)
        
        input.didSelectedWeeklyDay
            .map { ($0, weeklyDaysSubject.value) }
            .flatMap(useCase.getIsSelectedsWeeklyDay)
            .sink(receiveValue: weeklyDaysSubject.send)
            .store(in: &cancellables)

        Publishers.Merge3(
            input.didTapDailyButton.map { StudyRepeatType.dailiy },
            input.didTapWeeklyButton.map { StudyRepeatType.weekly([]) },
            input.didTapMonthlyButton.map { StudyRepeatType.monthly([]) }
        )
        .sink(receiveValue: selectedRepeatTypeSubject.send)
        .store(in: &cancellables)
        
        let selectedRepeatType = selectedRepeatTypeSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let monthlyDays = monthlyDaysSubject
            .filter { !$0.isEmpty }
            .map { $0.map { SelectStudyRepeatSectionItem.monthlyCell($0) } }
            .eraseToAnyPublisher()
        
        let isEnableCompleteButton = Publishers.CombineLatest3(
            selectedRepeatTypeSubject,
            weeklyDaysSubject,
            monthlyDaysSubject
        )
            .flatMap(useCase.getIsEnableCompleteButton)
            .eraseToAnyPublisher()
        
        let completeDays = input.didTapCompleteButton
            .map { (selectedRepeatTypeSubject.value, weeklyDaysSubject.value, monthlyDaysSubject.value) }
            .flatMap(useCase.getCompleteDays)
            .eraseToAnyPublisher()
        

        return Output(
            dismiss: dismiss,
            adjustHeight: adjustHeight,
            isRestoreBottomSheetView: isRestoreBottomSheetView,
            selectedRepeatType: selectedRepeatType,
            monthlyDays: monthlyDays,
            selectedWeeklyDays: weeklyDaysSubject.eraseToAnyPublisher(),
            isEnableCompleteButton: isEnableCompleteButton,
            completeDays: completeDays
        )
    }
}
