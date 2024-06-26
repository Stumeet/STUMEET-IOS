//
//  StudyActivitySettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import UIKit

final class StudyActivitySettingViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        
        return button
    }()
    
    private let topLabel: UILabel = {
        return UILabel().setLabelProperty(text: "활동 설정", font: StumeetFont.titleMedium.font, color: nil)
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let startDateLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium15.font, color: .primary700)
    }()
    
    private lazy var startDateButton: UIButton = {
        return createActivitySettingButton(title: "시작 일시", subTitleLabel: startDateLabel)
    }()
    
    private let endDateLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium15.font, color: .primary700)
    }()
    
    private lazy var endDateButton: UIButton = {
        return createActivitySettingButton(title: "종료 일시", subTitleLabel: endDateLabel)
    }()
    
    private let placeLabel: UILabel = {
        return UILabel().setLabelProperty(text: "장소를 선택해주세요", font: StumeetFont.bodyMedium15.font, color: .gray300)
    }()
    
    private lazy var placeButton: UIButton = {
        return createActivitySettingButton(title: "장소", subTitleLabel: placeLabel)
    }()
    
    private let memberLabel: UILabel = {
        return UILabel().setLabelProperty(text: "멤버를 선택해주세요", font: StumeetFont.bodyMedium15.font, color: .gray300)
    }()
    
    private lazy var memberButton: UIButton = {
        return createActivitySettingButton(title: "멤버", subTitleLabel: memberLabel)
    }()
    
    private lazy var postButton: UIButton = {
        return UIButton().makeRegisterBottomButton(text: "게시", color: StumeetColor.gray200.color)
    }()
    
    // MARK: - Properties
    
    private let viewModel: StudyActivitySettingViewModel
    private let coordinator: CreateActivityNavigation
    
    // MARK: - Init
    
    init(viewModel: StudyActivitySettingViewModel, coordinator: CreateActivityNavigation) {
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
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            startDateButton,
            endDateButton,
            placeButton,
            memberButton
        ]   .forEach { stackView.addArrangedSubview($0) }
        
        [
            topLabel,
            backButton,
            stackView,
            postButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        topLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(24)
            make.top.equalTo(backButton)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(268)
        }
        
        postButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(34)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        // Input
        let input = StudyActivitySettingViewModel.Input(
            didTapStartDateButton: startDateButton.tapPublisher,
            didTapEndDateButton: endDateButton.tapPublisher,
            didTapPlaceButton: placeButton.tapPublisher,
            didTapMemeberButton: memberButton.tapPublisher,
            didTapPostButton: postButton.tapPublisher)
        
        let output = viewModel.transform(input: input)
        
        // Output
        
        // CalendarBottomSheet으로 present
        output.showCalendarIsStart
            .map { (self, $0)}
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToBottomSheetCalendarVC)
            .store(in: &cancellables)
        
        // 현재 시간 update
        output.currentDate
            .receive(on: RunLoop.main)
            .sink(receiveValue: setCurrentDate)
            .store(in: &cancellables)
        
        output.presentToPlaceVC
            .map { self }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToActivityPlaceSettingVC)
            .store(in: &cancellables)
        
        // 멤버설정 VC present
        output.presentToParticipatingMemberVC
            .map { self }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToActivityMemberSettingViewController)
            .store(in: &cancellables)
    }
}

// MARK: - CalendarDelegate

extension StudyActivitySettingViewController: CreateActivityDelegate {
    
    func didTapStartDateCompleteButton(date: String) {
        startDateLabel.text = date
    }
    
    func didTapEndDateCompleteButton(date: String) {
        endDateLabel.text = date
    }
}

extension StudyActivitySettingViewController: CreateActivityMemberDelegate {
    func didTapCompleteButton(name: [String]) {
        print(name)
    }
}

extension StudyActivitySettingViewController: CreateActivityPlaceDelegate {
    func didTapCompleteButton(place: String) {
        placeLabel.text = place
        placeLabel.textColor = StumeetColor.primary700.color
    }
}

// MARK: - UpdateUI

extension StudyActivitySettingViewController {
    func createActivitySettingButton(title: String, subTitleLabel: UILabel) -> UIButton {
        let button = UIButton()
        
        let titleLabel = UILabel().setLabelProperty(text: title, font: StumeetFont.bodyMedium16.font, color: nil)
        subTitleLabel.textAlignment = .right
        
        button.addSubview(titleLabel)
        button.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(titleLabel.snp.trailing).offset(24)
            make.centerY.equalToSuperview()
        }
        
        return button
    }
    
    func setCurrentDate(date: String) {
        startDateLabel.text = date
        endDateLabel.text = date
    }
}
