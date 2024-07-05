//
//  StudyActivitySettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import Combine
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
    
    // MARK: - Subject
    
    private let memberSubject = CurrentValueSubject<[ActivityMember]?, Never>(nil)
    
    
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
            didSelectedMembers: memberSubject.eraseToAnyPublisher(),
            didTapPostButton: postButton.tapPublisher,
            didTapBackButton: backButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        // Output
        
        output.currentCategory
            .filter { $0 == .homework }
            .map { _ in }
            .receive(on: RunLoop.main)
            .sink(receiveValue: reConfigureConstraints)
            .store(in: &cancellables)
        
        // CalendarBottomSheet으로 present
        output.showCalendarIsStart
            .map { (self, $0)}
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToBottomSheetCalendarVC)
            .store(in: &cancellables)
        
        // 현재 시간 update
        output.currentDates
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
            .map { self.memberSubject.value ?? [] }
            .map { ($0, self) }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToActivityMemberSettingViewController)
            .store(in: &cancellables)
        
        output.selectedMembers
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateMemberButton)
            .store(in: &cancellables)
        
        output.popViewController
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.popViewController)
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
    func didTapCompleteButton(members: [ActivityMember]) {
        memberSubject.send(members)
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
    
    func setCurrentDate(startDate: String, endDate: String) {
        startDateLabel.text = startDate
        endDateLabel.text = endDate
    }
    
    func reConfigureConstraints() {
        placeButton.removeFromSuperview()
        stackView.removeArrangedSubview(placeButton)
        stackView.snp.updateConstraints { make in
            make.height.equalTo(201)
        }
    }
    
    private func updateMemberButton(with members: [ActivityMember]) {

        memberButton.subviews.dropFirst().forEach { $0.removeFromSuperview() }
        
        let memberStackView = createMemberImageView(members: members)
        memberButton.addSubview(memberStackView)
        
        if members.count > 4 {
            let count = members.count - 4
            let othersMemberCountLabel = UILabel().setLabelProperty(text: "+\(count)", font: StumeetFont.bodyMedium14.font, color: .gray500)
            
            memberButton.addSubview(othersMemberCountLabel)
            
            othersMemberCountLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(24)
                make.centerY.equalToSuperview()
            }
            
            
            memberStackView.snp.makeConstraints { make in
                make.trailing.equalTo(othersMemberCountLabel.snp.leading).offset(-4)
                make.centerY.equalToSuperview()
            }
        } else {
            memberStackView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(24)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    // TODO: - image 변경
    
    private func createMemberImageView(members: [ActivityMember]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = -8
        stackView.alignment = .trailing
        stackView.isUserInteractionEnabled = false
        
        let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green]
        
        for (index, member) in members.enumerated() {
            if index >= 4 { break }
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = colors[index]
            stackView.addArrangedSubview(imageView)
            imageView.layer.zPosition = CGFloat(-index)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(24)
            }
        }
        
        return stackView
    }
}
