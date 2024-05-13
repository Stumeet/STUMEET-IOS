//
//  BottomSheetCalendarViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//
import Combine
import UIKit

protocol CreateActivityDelegate: AnyObject {
    func didTapStartDateCompleteButton(date: String)
    func didTapEndDateCompleteButton(date: String)
}

class BottomSheetCalendarViewController: BaseViewController {
    // MARK: - UIComponents
    
    private let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0
        
        return button
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    
    private let dragIndicatorContainerView = UIView()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        view.layer.cornerRadius = 7
        return view
        
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.attributedTitle?.font = StumeetFont.bodyMedium15.font
        config.image = UIImage(named: "calendar")
        config.imagePadding = 4
        config.baseForegroundColor = StumeetColor.primary700.color
        config.attributedTitle = AttributedString()
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(named: "clock")
        config.imagePadding = 4
        config.attributedTitle?.font = StumeetFont.bodyMedium15.font
        config.attributedTitle = .init("시간 선택...")
        
        config.baseForegroundColor = StumeetColor.gray400.color
        config.contentInsets = .init(top: 0, leading: 19.5, bottom: 0, trailing: 19.5)
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.gray75.color.cgColor
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("완료", for: .normal)
        button.setTitleColor(StumeetColor.gray50.color, for: .normal)
        button.backgroundColor = StumeetColor.gray200.color
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let calendarView = CalendarView()
    private let timeView: TimeView = {
        let view = TimeView()
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - Properties
    
    private let viewModel: BottomSheetCalendarViewModel
    private let coordinator: CreateActivityNavigation
    private var datasource: UICollectionViewDiffableDataSource<CalendarSection, CalendarSectionItem>?
    weak var delegate: CreateActivityDelegate?
    
    // MARK: - Init
    
    init(viewModel: BottomSheetCalendarViewModel, coordinator: CreateActivityNavigation) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    // MARK: - SetUp
    
    override func setupAddView() {
        
        [
            dragIndicatorView
        ]   .forEach { dragIndicatorContainerView.addSubview($0) }
        
        
        [
            dragIndicatorContainerView,
            calendarButton,
            dateButton,
            calendarView,
            timeView,
            completeButton
        ]   .forEach { bottomSheetView.addSubview($0) }
        
        [
            backgroundButton,
            bottomSheetView
        ]   .forEach { view.addSubview($0) }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dragIndicatorContainerView.addGestureRecognizer(panGesture)
        
    }
    
    override func setupConstaints() {
        
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        dragIndicatorContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(30)
            make.width.equalTo(72)
        }
        
        dragIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(8)
        }
        
        calendarButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(56)
            make.width.equalTo(191)
        }
        
        dateButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(56)
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(dateButton.snp.bottom).offset(25)
            make.height.equalTo(261)
        }
        
        timeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dateButton.snp.bottom).offset(24)
            make.height.equalTo(267)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(calendarButton.snp.bottom).offset(318)
            make.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        let didSelectedItemPublisher = calendarView.calendarCollectionView.didSelectItemPublisher.filter { $0.section == 1 }
        
        let didTapHourButtonPublisher = Publishers.MergeMany(timeView.hourButtons.enumerated()
            .map { index, button in button.tapPublisher.map { index } })
        
        let didTapMinuteButtonPublisher = Publishers.MergeMany(timeView.minuteButtons.enumerated()
            .map { index, button in button.tapPublisher.map { index } })
        
        let didTapAmButtonTapPublisher = timeView.amButton.tapPublisher
        let didTapPmButtonTapPublisher = timeView.pmButton.tapPublisher
        
        let input = BottomSheetCalendarViewModel.Input(
            didTapBackgroundButton: backgroundButton.tapPublisher,
            didTapCalendarButton: calendarButton.tapPublisher,
            didTapDateButton: dateButton.tapPublisher,
            didTapNextMonthButton: calendarView.nextMonthButton.tapPublisher,
            didTapBackMonthButton: calendarView.backMonthButton.tapPublisher,
            didSelectedCalendarCell: didSelectedItemPublisher.eraseToAnyPublisher(),
            didTapHourButton: didTapHourButtonPublisher.eraseToAnyPublisher(),
            didTapMinuteButton: didTapMinuteButtonPublisher.eraseToAnyPublisher(),
            didTapAmButtonTapPublisher: didTapAmButtonTapPublisher.eraseToAnyPublisher(),
            didTapPmButtonTapPublisher: didTapPmButtonTapPublisher.eraseToAnyPublisher(),
            didTapCompleteButton: completeButton.tapPublisher.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        // 배경 화면 터치시 dismiss
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: hideBottomSheet)
            .store(in: &cancellables)
        
        // bottomSheet 높이 조정
        output.adjustHeight
            .receive(on: RunLoop.main)
            .sink(receiveValue: adjustBottomSheetHeight)
            .store(in: &cancellables)
        
        // bottomSheet 최대 높이로 되돌리기, 없애기
        output.isRestoreBottomSheetView
            .receive(on: RunLoop.main)
            .sink { [weak self] isRestore in
                if isRestore {
                    self?.hideBottomSheet()
                } else { self?.showBottomSheet() }
            }
            .store(in: &cancellables)
        
        // calendar binding
        output.calendarSectionItems
            .receive(on: RunLoop.main)
            .map(updateSnapshot)
            .sink(receiveValue: { [weak self] snapshot in
                guard let datasource = self?.datasource else { return }
                datasource.apply(snapshot, animatingDifferences: false)
            })
            .store(in: &cancellables)
        
        // calendar 이전 달 버튼 enable 설정
        output.isEnableBackMonthButton
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: setEnableBackMonthButton)
            .store(in: &cancellables)
        
        // 선택된 날짜 binding
        output.selectedDate
            .receive(on: RunLoop.main)
            .assign(to: \.configuration!.attributedTitle, on: calendarButton)
            .store(in: &cancellables)
        
        // 연도, 월 binding
        output.yearMonthTitle
            .map { ($0, UIControl.State.normal) }
            .receive(on: RunLoop.main)
            .sink(receiveValue: calendarView.yearMonthButton.setTitle)
            .store(in: &cancellables)
        
        // 선택된 날짜 binding
        output.selectedDate
            .receive(on: RunLoop.main)
            .assign(to: \.configuration!.attributedTitle, on: calendarButton)
            .store(in: &cancellables)
        
        // 캘린더 뷰 보여주기
        output.showCalendar
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateShowCalendar)
            .store(in: &cancellables)
        
        // 일시 선택 뷰 보여주기
        output.showDate
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateShowDate)
            .store(in: &cancellables)
        
        // 시간 버튼 UI 업데이트
        output.isSelectedHours
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateHourButton)
            .store(in: &cancellables)
        
        // 분 버튼 UI 업데이트
        output.isSelectedMinute
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateMinuteButton)
            .store(in: &cancellables)
        
        output.isSelectedAmButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isSelected in
                self?.updateAmTimeView(isSelected: isSelected)
                self?.updatePmTimeView(isSelected: isSelected)
            })
            .store(in: &cancellables)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCompleteButton)
            .store(in: &cancellables)
        
        output.completeDate
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] date, isStart in
                if isStart {
                    self?.delegate?.didTapStartDateCompleteButton(date: date)
                } else { self?.delegate?.didTapEndDateCompleteButton(date: date) }
                self?.coordinator.dismissBottomSheetCalenderVC()
            })
            .store(in: &cancellables)
    }
}

// MARK: - Datasource

extension BottomSheetCalendarViewController {
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(
            collectionView: calendarView.calendarCollectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .weekCell(let week):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CalendarCell.identifier,
                    for: indexPath) as? CalendarCell
                else { return UICollectionViewCell() }
                
                cell.configureWeekCell(text: week)
                return cell
                
            case .dayCell(let calendarDate):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CalendarCell.identifier,
                    for: indexPath) as? CalendarCell
                else { return UICollectionViewCell() }
                
                cell.configureDayCell(item: calendarDate)
                
                return cell
            }
        }
    }
    
    private func updateSnapshot(items: [CalendarSectionItem]) -> NSDiffableDataSourceSnapshot<CalendarSection, CalendarSectionItem> {
        var snapshot = NSDiffableDataSourceSnapshot<CalendarSection, CalendarSectionItem>()
        snapshot.appendSections([.week, .day])
        
        items.forEach {
            switch $0 {
            case .weekCell(let week):
                snapshot.appendItems([.weekCell(week)], toSection: .week)
            case .dayCell(let item):
                snapshot.appendItems([.dayCell(item)], toSection: .day)
            }
        }
        
        return snapshot
    }
}

// MARK: - UI Update

extension BottomSheetCalendarViewController {
    
    // bottomSheetView 드래그에 맞게 높이 조정
    private func adjustBottomSheetHeight(_ height: CGFloat) {
        self.bottomSheetView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        self.view.layoutIfNeeded()
    }
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(536)
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
    
    // bottomSheetView 숨기기
    private func hideBottomSheet() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.bottomSheetView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.backgroundButton.alpha = 0
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.coordinator.dismissBottomSheetCalenderVC()
            })
    }
    
    private func setEnableBackMonthButton(isEnable: Bool) {
        if isEnable {
            calendarView.backMonthButton.tintColor = StumeetColor.gray300.color
        } else {
            calendarView.backMonthButton.tintColor = StumeetColor.gray800.color
        }
        calendarView.backMonthButton.isEnabled = isEnable
    }
    
    private func updateHourButton(isSelecteds: [Bool]) {
        for index in isSelecteds.indices {
            timeView.hourButtons[index].isSelected = isSelecteds[index]
            if isSelecteds[index] {
                timeView.hourButtons[index].backgroundColor = StumeetColor.primary700.color
            } else {
                timeView.hourButtons[index].backgroundColor = StumeetColor.gray75.color
            }
        }
    }
    
    private func updateMinuteButton(isSelecteds: [Bool]) {
        for index in isSelecteds.indices {
            timeView.minuteButtons[index].isSelected = isSelecteds[index]
            if isSelecteds[index] {
                timeView.minuteButtons[index].backgroundColor = StumeetColor.primary700.color
            } else {
                timeView.minuteButtons[index].backgroundColor = StumeetColor.gray75.color
            }
        }
    }
    
    private func updateShowDate() {
        calendarView.isHidden = true
        timeView.isHidden = false
        dateButton.configuration?.baseForegroundColor = StumeetColor.primary700.color
        dateButton.layer.borderColor = StumeetColor.primary700.color.cgColor
        dateButton.configuration?.image = UIImage(named: "clock")?.withTintColor(StumeetColor.primary700.color)
        
        calendarButton.configuration?.baseForegroundColor = StumeetColor.gray400.color
        calendarButton.layer.borderColor = StumeetColor.gray75.color.cgColor
        calendarButton.configuration?.image = UIImage(named: "calendar")?.withTintColor(StumeetColor.gray400.color)
    }
    
    private func updateShowCalendar() {
        calendarView.isHidden = false
        calendarButton.configuration?.baseForegroundColor = StumeetColor.primary700.color
        calendarButton.configuration?.image = UIImage(named: "calendar")
        calendarButton.layer.borderColor = StumeetColor.primary700.color.cgColor
        
        dateButton.configuration?.baseForegroundColor = StumeetColor.gray400.color
        dateButton.layer.borderColor = StumeetColor.gray75.color.cgColor
        dateButton.configuration?.image = UIImage(named: "clock")
        timeView.isHidden = true
    }
                
    private func updateAmTimeView(isSelected: Bool) {
        if isSelected {
            timeView.amButton.setTitleColor(StumeetColor.primary700.color, for: .normal)
            timeView.amButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            timeView.amButton.layer.borderWidth = 1
            timeView.amButton.backgroundColor = .white
        } else {
            timeView.amButton.setTitleColor(StumeetColor.gray400.color, for: .normal)
            timeView.amButton.backgroundColor = StumeetColor.gray75.color
            timeView.amButton.layer.borderWidth = 0
        }
    }
    
    private func updatePmTimeView(isSelected: Bool) {
        if isSelected {
            timeView.pmButton.setTitleColor(StumeetColor.gray400.color, for: .normal)
            timeView.pmButton.backgroundColor = StumeetColor.gray75.color
            timeView.pmButton.layer.borderWidth = 0
        } else {
            timeView.pmButton.setTitleColor(StumeetColor.primary700.color, for: .normal)
            timeView.pmButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            timeView.pmButton.layer.borderWidth = 1
            timeView.pmButton.backgroundColor = .white
        }
    }
    
    private func updateCompleteButton(isEnable: Bool) {
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
        completeButton.isEnabled = isEnable
    }
}

// MARK: - ObjcFunc

extension BottomSheetCalendarViewController {
    
    // indicatorView 드래그 감지
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let state: BottomSheetCalendarViewModel.DragState
        switch gesture.state {
        case .began: state = .began
        case .changed: state = .changed
        case .ended: state = .ended
        case .cancelled: state = .cancelled
        default: return
        }
        
        let translation = gesture.translation(in: self.view)
        let velocity = gesture.velocity(in: self.view)
        let dragInfo = BottomSheetCalendarViewModel.DragInfo(
            state: state,
            translationY: translation.y,
            velocityY: velocity.y,
            bottomSheetViewHeight: self.bottomSheetView.frame.height)
        
        viewModel.dragEventSubject.send(dragInfo)
        gesture.setTranslation(.zero, in: self.view)
    }
}
