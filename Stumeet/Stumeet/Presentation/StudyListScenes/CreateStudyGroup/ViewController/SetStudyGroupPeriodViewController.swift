//
//  SetStudyGroupPeriodViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 7/31/24.
//

import Combine
import UIKit

protocol SetStudyGroupPeriodDelegate: AnyObject {
    func didTapCompleteButton(startDate: Date, endDate: Date)
}

class SetStudyGroupPeriodViewController: BaseViewController {
    
    typealias Section = CalendarSection
    typealias SectionItem = CalendarSectionItem
    
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
    
    private let startDateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.imagePadding = 4
        config.image = UIImage(resource: .calendar)
        
        var titleAttributes = AttributedString()
        titleAttributes.font = StumeetFont.bodyMedium14.font
        config.baseForegroundColor = StumeetColor.primary700.color
        config.attributedTitle = titleAttributes
        
        button.configuration = config
        
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let ingLabel = UILabel().setLabelProperty(text: "~", font: StumeetFont.bodyMedium15.font, color: .gray800)
    
    private let endDateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(resource: .calendar).withTintColor(StumeetColor.gray400.color)
        config.imagePadding = 4
        
        var titleAttributes = AttributedString("날짜 선택...")
        titleAttributes.font = StumeetFont.bodyMedium14.font
        config.attributedTitle = titleAttributes
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.gray75.color.cgColor
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let calendarView = CalendarView()
    
    private let completeButton = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    
    // MARK: - Properties
    
    private let coordinator: CreateStudyGroupNavigation
    private let viewModel: SetStudyGroupPeriodViewModel
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    weak var delegate: SetStudyGroupPeriodDelegate?
    
    // MARK: - Subject
    
    private let dragEventSubject = PassthroughSubject<SetStudyGroupPeriodViewModel.DragInfo, Never>()
    
    // MARK: - Init
    
    init(coordinator: CreateStudyGroupNavigation, viewModel: SetStudyGroupPeriodViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
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
            startDateButton,
            ingLabel,
            endDateButton,
            calendarView,
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
        
        startDateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(35)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(52)
        }
        
        ingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(startDateButton)
            make.leading.equalTo(startDateButton.snp.trailing).offset(17)
            make.width.equalTo(12)
        }
        
        endDateButton.snp.makeConstraints { make in
            make.leading.equalTo(ingLabel.snp.trailing).offset(17)
            make.trailing.equalToSuperview().inset(35)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(52)
            make.width.equalTo(startDateButton.snp.width)
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(startDateButton.snp.bottom).offset(25)
            make.height.equalTo(261)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(startDateButton.snp.bottom).offset(318)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        let input = SetStudyGroupPeriodViewModel.Input(
            didTapBackgroundButton: backgroundButton.tapPublisher,
            didDragEvent: dragEventSubject.eraseToAnyPublisher(),
            didTapNextMonthButton: calendarView.nextMonthButton.tapPublisher, didTapBackMonthButton: calendarView.backMonthButton.tapPublisher,
            didSelectedCalendarCell: calendarView.calendarCollectionView.didSelectItemPublisher,
            didTapStartDateButton: startDateButton.tapPublisher,
            didTapEndDateButton: endDateButton.tapPublisher,
            didTapCompleteButton: completeButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: hideBottomSheet)
            .store(in: &cancellables)
        
        output.adjustHeight
            .receive(on: RunLoop.main)
            .sink(receiveValue: adjustBottomSheetHeight)
            .store(in: &cancellables)
    
        output.isRestoreBottomSheetView
            .receive(on: RunLoop.main)
            .sink { [weak self] isRestore in
                if isRestore {
                    self?.hideBottomSheet()
                } else { self?.showBottomSheet() }
            }
            .store(in: &cancellables)
        
        output.calendarSectionItems
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        output.yearMonthTitle
            .receive(on: RunLoop.main)
            .sink(receiveValue: calendarView.setYearMonthButtonTitle)
            .store(in: &cancellables)
        
        output.selectedStartDate
            .receive(on: RunLoop.main)
            .assign(to: \.configuration!.attributedTitle, on: startDateButton)
            .store(in: &cancellables)
        
        output.selectedEndDate
            .receive(on: RunLoop.main)
            .assign(to: \.configuration!.attributedTitle, on: endDateButton)
            .store(in: &cancellables)
        
        output.isEnableBackMonthButton
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: calendarView.setEnableBackMonthButton)
            .store(in: &cancellables)
        
        output.isSelectedStartDateButton
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateStartEndDateButton)
            .store(in: &cancellables)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCompleteEnableButton)
            .store(in: &cancellables)
        
        output.selectedPeriod
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] period in
                self?.delegate?.didTapCompleteButton(startDate: period.startDate, endDate: period.endDate)
                self?.coordinator.dismiss()
            })
            .store(in: &cancellables)
    }
}

// MARK: - Datasource 

extension SetStudyGroupPeriodViewController {
    
    private func configureDatasource() {
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
    
    private func updateSnapshot(items: [CalendarSectionItem]) {
        guard let datasource = datasource else { return }
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
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UIUpdate

extension SetStudyGroupPeriodViewController {
    
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
                self.coordinator.dismiss()
            })
    }
    
    private func updateStartEndDateButton(isStart: Bool) {
        
        let image = UIImage(resource: .calendar)
        
        startDateButton.layer.borderColor = isStart ? StumeetColor.primary700.color.cgColor : StumeetColor.gray75.color.cgColor
        startDateButton.configuration?.baseForegroundColor = isStart ? StumeetColor.primary700.color : StumeetColor.gray400.color
        endDateButton.layer.borderColor = isStart ? StumeetColor.gray75.color.cgColor : StumeetColor.primary700.color.cgColor
        endDateButton.configuration?.baseForegroundColor = isStart ? StumeetColor.gray400.color : StumeetColor.primary700.color
        startDateButton.configuration?.image =  isStart ? image : image.withTintColor(StumeetColor.gray400.color)
        endDateButton.configuration?.image = isStart ? image.withTintColor(StumeetColor.gray400.color) : image
    }
    
    private func updateCompleteEnableButton(isEnable: Bool) {
        completeButton.isEnabled = isEnable
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
    }
}

// MARK: - ObjcFunc

extension SetStudyGroupPeriodViewController {
    
    // indicatorView 드래그 감지

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let state: SetStudyGroupPeriodViewModel.DragState
        switch gesture.state {
        case .began: state = .began
        case .changed: state = .changed
        case .ended: state = .ended
        case .cancelled: state = .cancelled
        default: return
        }
        
        let translation = gesture.translation(in: self.view)
        let velocity = gesture.velocity(in: self.view)
        let dragInfo = SetStudyGroupPeriodViewModel.DragInfo(
            state: state,
            translationY: translation.y,
            velocityY: velocity.y,
            bottomSheetViewHeight: self.bottomSheetView.frame.height)
        
        dragEventSubject.send(dragInfo)
        gesture.setTranslation(.zero, in: self.view)
    }
}
