//
//  SelectStudyRepeatViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 8/10/24.
//

import Combine
import UIKit

protocol SelectStudyRepeatDelegate: AnyObject {
    func didTapCompleteButton(repeatType: String, repeatDates: [String])
}

final class SelectStudyRepeatViewController: BaseViewController {
    
    typealias Section = SelectStudyRepeatSection
    typealias SectionItem = SelectStudyRepeatSectionItem
    
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
    
    private let repeatTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 9
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var dailyButton = makeRepeatTypeButton(text: "매일")
    private lazy var weeklyButton = makeRepeatTypeButton(text: "매주")
    private lazy var monthlyButton = makeRepeatTypeButton(text: "매월")
    
    private var weeklyButtons: [UIButton] = []
    
    private lazy var weeklyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        
        let titles = ["월", "화", "수", "목", "금", "토", "일"]
        
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(StumeetColor.gray400.color, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = StumeetFont.bodyMedium14.font
            button.backgroundColor = StumeetColor.gray75.color
            button.layer.cornerRadius = 8
            
            weeklyButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }()
    
    private lazy var monthlyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(MonthlyCell.self)
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    private let lastDayExplainLabel: UILabel = {
        let label = UILabel().setLabelProperty(text: "!마지막 날을 선택하면 매 달의 마지막 날에 반복돼요.", font: StumeetFont.captionMedium13.font, color: .warning500)
        
        label.isHidden = true
        
        return label
    }()

    
    private let completeButton = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    
    // MARK: - Properties
    
    private let coordinator: CreateStudyGroupNavigation
    private let viewModel: SelectStudyRepeatViewModel
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    weak var delegate: SelectStudyRepeatDelegate?
    
    // MARK: - Init
    
    init(coordinator: CreateStudyGroupNavigation, viewModel: SelectStudyRepeatViewModel) {
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
        showBottomSheet(height: 245)
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        
    }
    
    override func setupAddView() {
        [
            dragIndicatorView
        ]   .forEach { dragIndicatorContainerView.addSubview($0) }
        
        [
            dailyButton,
            weeklyButton,
            monthlyButton
        ]   .forEach(repeatTypeStackView.addArrangedSubview)
        
        [
            dragIndicatorContainerView,
            repeatTypeStackView,
            weeklyStackView,
            monthlyCollectionView,
            lastDayExplainLabel,
            completeButton
        ]   .forEach { bottomSheetView.addSubview($0) }
        
        [
            backgroundButton,
            bottomSheetView
        ]   .forEach { view.addSubview($0) }
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
        
        repeatTypeStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(51)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
        }
        
        weeklyStackView.snp.makeConstraints { make in
            make.top.equalTo(repeatTypeStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(328)
        }
        
        monthlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(repeatTypeStackView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
            make.width.equalTo(328)
            make.height.equalTo(232)
        }
        
        lastDayExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(monthlyCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(monthlyCollectionView.snp.leading).offset(-4)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(repeatTypeStackView.snp.bottom).offset(34)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        
        let didTapWeeklyButtonPublisher = Publishers.MergeMany(weeklyButtons.enumerated()
            .map { index, button in button.tapPublisher.map { index } })
            .eraseToAnyPublisher()
        
        let input = SelectStudyRepeatViewModel.Input(
            didTapDailyButton: dailyButton.tapPublisher,
            didTapWeeklyButton: weeklyButton.tapPublisher,
            didTapMonthlyButton: monthlyButton.tapPublisher,
            didSelectedMontlhyDay: monthlyCollectionView.didSelectItemPublisher,
            didSelectedWeeklyDay: didTapWeeklyButtonPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedRepeatType
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateRepeatButtons)
            .store(in: &cancellables)
        
        output.selectedWeeklyDays // 추가: Weekly Day 선택 상태 바인딩
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateWeeklyButtons)
            .store(in: &cancellables)
        
        output.monthlyDays
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCompleteButton)
            .store(in: &cancellables)
    }
}

// MARK: - ConfigureUI

extension SelectStudyRepeatViewController {
    private func makeRepeatTypeButton(text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(StumeetColor.gray400.color, for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .selected)
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.gray75.color.cgColor
        button.layer.cornerRadius = 16
        button.titleLabel?.font = StumeetFont.bodyMedium15.font
        
        return button
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func remakeCompleteButtonConstraints() {
        completeButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(72)
        }
    }
}

// MARK: - Datasource

extension SelectStudyRepeatViewController {
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: monthlyCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .monthlyCell(let day):
                guard let cell = collectionView.dequeue(MonthlyCell.self, for: indexPath) else { return UICollectionViewCell() }
                
                cell.updateCell(day: day)
                return cell
            }
        })
    }
    
    private func updateSnapshot(days: [SectionItem]) {
        guard let datasource = datasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(days, toSection: .main)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
                

// MARK: - UpdateUI

extension SelectStudyRepeatViewController {
    
    private func adjustBottomSheetHeight(_ height: CGFloat) {
        self.bottomSheetView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        self.view.layoutIfNeeded()
    }
    
    private func showBottomSheet(height: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
    
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
    
    private func updateRepeatButtons(type: StudyRepeatType) {
        showBottomSheet(height: type.height)
        remakeCompleteButtonConstraints()
        
        let buttons = [dailyButton, weeklyButton, monthlyButton]
        buttons.forEach { button in
            button.isSelected = false
            button.layer.borderColor = StumeetColor.gray75.color.cgColor
        }
        
        switch type {
        case .dailiy:
            dailyButton.isSelected = true
            dailyButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            weeklyStackView.isHidden = true
            monthlyCollectionView.isHidden = true
            
        case .weekly:
            weeklyButton.isSelected = true
            weeklyButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            weeklyStackView.isHidden = false
            monthlyCollectionView.isHidden = true
            
        case .monthly:
            monthlyButton.isSelected = true
            monthlyButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            weeklyStackView.isHidden = true
            monthlyCollectionView.isHidden = false
        }
    }
    
    private func updateWeeklyButtons(isSelecteds: [Bool]) {
        for idx in isSelecteds.indices {
            weeklyButtons[idx].isSelected = isSelecteds[idx]
            weeklyButtons[idx].backgroundColor = isSelecteds[idx] ? StumeetColor.primary700.color : StumeetColor.gray75.color
        }
    }
    
    private func updateCompleteButton(isEnable: Bool) {
        completeButton.isEnabled = isEnable
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
    }
}
