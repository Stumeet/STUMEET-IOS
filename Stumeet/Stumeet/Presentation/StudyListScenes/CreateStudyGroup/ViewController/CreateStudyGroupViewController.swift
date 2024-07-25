//
//  CreateStudyGroupViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 7/24/24.
//

import UIKit

final class CreateStudyGroupViewController: BaseViewController {

    // MARK: - UIComponents
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark), for: .normal)
        
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let scrollViewVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let imageContainerView = UIView()
    private let studyGroupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemOrange
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    private let randomColorButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .systemBlue
        button.setRoundCorner()
        
        return button
    }()
    private let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .CreateStudyGroup.uplodaImageButton), for: .normal)
        button.setRoundCorner()
        
        return button
    }()
    
    private let studyNameContainerView = UIView()
    private let studyNameLabel = createEssentialLabel(text: "스터디 이름 *")
    private let studyNameTextField: UITextField = {
        let textField = UITextField()
        textField.addLeftPadding(24)
        textField.placeholder = "스터디 이름을 입력해주세요."
        textField.setPlaceholder(font: .bodyMedium14, color: .gray400)
        textField.layer.cornerRadius = 16
        textField.backgroundColor = StumeetColor.primary50.color
        return textField
    }()
    private let studyNameLengthLabel = UILabel().setLabelProperty(text: "0/20", font: StumeetFont.bodyMedium14.font, color: .gray400)
    
    private let fieldContainerView = UIView()
    private let fieldLabel: UILabel = createEssentialLabel(text: "분야 *")
    private let fieldButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = StumeetColor.primary50.color
        button.layer.cornerRadius = 16

        var config = UIButton.Configuration.plain()
        var titleAttributes = AttributedString("분야 선택...")
        titleAttributes.font = StumeetFont.bodyMedium14.font
        titleAttributes.foregroundColor = StumeetColor.gray400.color
        config.attributedTitle = titleAttributes

        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 16)

        button.configuration = config
        button.contentHorizontalAlignment = .left

        return button
    }()
    
    private let tagContainerView = UIView()
    private let tagLabel = createEssentialLabel(text: "태그 *")
    private let tagTextField: UITextField = {
        let textField = UITextField()
        textField.addLeftPadding(24)
        textField.placeholder = "태그를 직접 입략해주세요.(최대 5개)"
        textField.setPlaceholder(font: .bodyMedium14, color: .gray400)
        textField.layer.cornerRadius = 16
        textField.backgroundColor = StumeetColor.primary50.color
        return textField
    }()
    private let tagAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = StumeetColor.primary700.color
        button.titleLabel?.font = StumeetFont.bodyMedium14.font
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let explainContainerView = UIView()
    private let explainLabel = UILabel().setLabelProperty(text: "스터디 소개", font: StumeetFont.bodysemibold.font, color: .gray800)
    private let explainTextView = createTextView(placeholder: "스터디를 소개해주세요.")
    private let explainLengthLabel = UILabel().setLabelProperty(text: "0/100", font: StumeetFont.captionMedium13.font, color: .gray400)
    
    private let regionContainerView = UIView()
    private let regionLabel = createEssentialLabel(text: "지역 *")
    private let regionButton = createConfigButton(title: "지역 선택...", image: UIImage(resource: .CreateStudyGroup.regionButton), radius: 16)
    
    private let periodContainerView = UIView()
    private let periodLabel: UILabel = createEssentialLabel(text: "진행 기간 *")
    private let periodStartButton = createConfigButton(title: "2024.01.08", image: UIImage(resource: .calendar), radius: 16)
    private let periodIngLabel = UILabel().setLabelProperty(text: "~", font: StumeetFont.bodyMedium15.font, color: .gray800)
    private let periodEndButton = createConfigButton(title: "날짜 선택", image: UIImage(resource: .calendar), radius: 16)
    
    private let studyMeetingContainerView = UIView()
    private let studyMeetingLabel = createEssentialLabel(text: "스터디 정기 모임 *")
    private let timeLabel = UILabel().setLabelProperty(text: "시간", font: StumeetFont.bodyMedium15.font, color: .gray800)
    private let timeButton = createConfigButton(title: "시간 선택", image: UIImage(resource: .CreateStudyGroup.clock), radius: 18)
    private let repeatLabel = UILabel().setLabelProperty(text: "반복", font: StumeetFont.bodyMedium15.font, color: .gray800)
    private let repeatButton: UIButton = createConfigButton(title: "반복 선택", image: UIImage(resource: .CreateStudyGroup.repeatButton), radius: 18)
    
    private let studyRuleContainerView = UIView()
    private let studyRuleLabel = UILabel().setLabelProperty(text: "스터디 규칙", font: StumeetFont.bodysemibold.font, color: .gray800)
    private let studyRuleTextView = createTextView(placeholder: "스터디를 소개해주세요.")
    private let studyRuleLengthLabel = UILabel().setLabelProperty(text: "0/100", font: StumeetFont.captionMedium13.font, color: .gray400)
    private let completeButton = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.primary700.color)
    
    // MARK: - Properties
    
    private let coordinator: CreateStudyGroupNavigation
    private let viewModel: CreateStudyGroupViewModel
    
    // MARK: - Init
    
    init(coordinator: CreateStudyGroupNavigation, viewModel: CreateStudyGroupViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
        configureXButtonTitleNavigationBarItems(button: UIBarButtonItem(customView: xButton), title: "스터디 그룹 생성")
    }
    
    override func setupAddView() {
        [
            studyGroupImageView,
            addImageButton,
            randomColorButton
        ]   .forEach(imageContainerView.addSubview)
        
        [
            studyNameLabel,
            studyNameTextField,
            studyNameLengthLabel
        ]   .forEach(studyNameContainerView.addSubview)
        
        [
            fieldLabel,
            fieldButton
        ]   .forEach(fieldContainerView.addSubview)
        
        [
            tagLabel,
            tagTextField,
            tagAddButton
        ]   .forEach(tagContainerView.addSubview)
        
        [
            explainLabel,
            explainTextView,
            explainLengthLabel
        ]   .forEach(explainContainerView.addSubview)
        
        [
            regionLabel,
            regionButton
        ]   .forEach(regionContainerView.addSubview)
        
        [
            periodLabel,
            periodStartButton,
            periodIngLabel,
            periodEndButton
        ]   .forEach(periodContainerView.addSubview)
        
        [
            studyMeetingLabel,
            timeLabel,
            timeButton,
            repeatLabel,
            repeatButton
        ]   .forEach(studyMeetingContainerView.addSubview)
        
        [
            studyRuleLabel,
            studyRuleTextView,
            studyRuleLengthLabel
        ]   .forEach(studyRuleContainerView.addSubview)
        
        
        [
            imageContainerView,
            studyNameContainerView,
            fieldContainerView,
            tagContainerView,
            explainContainerView,
            regionContainerView,
            periodContainerView,
            studyMeetingContainerView,
            studyRuleContainerView
        ]   .forEach(scrollViewVStackView.addArrangedSubview)
        
        [
            scrollViewVStackView
        ]   .forEach(scrollView.addSubview)
        
        [
            scrollView,
            completeButton
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        scrollViewVStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide).inset(96)
        }
        
        studyGroupImageView.snp.makeConstraints { make in
            make.height.equalTo(192)
            make.edges.equalToSuperview()
        }
        
        addImageButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(studyGroupImageView).inset(16)
            make.size.equalTo(32)
        }
        
        randomColorButton.snp.makeConstraints { make in
            make.bottom.equalTo(addImageButton)
            make.trailing.equalTo(addImageButton.snp.leading).offset(-8)
            make.size.equalTo(32)
        }
        
        studyNameLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        studyNameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(studyNameLabel.snp.bottom).offset(8)
            make.height.equalTo(49)
            make.bottom.equalToSuperview()
        }

        studyNameLengthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(studyNameTextField)
        }
        
        fieldLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        fieldButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(fieldLabel.snp.bottom).offset(8)
            make.height.equalTo(49)
            make.bottom.equalToSuperview()
        }

        tagLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        tagTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(tagLabel.snp.bottom).offset(8)
            make.height.equalTo(49)
        }

        tagAddButton.snp.makeConstraints { make in
            make.top.equalTo(tagTextField)
            make.trailing.equalToSuperview()
            make.leading.equalTo(tagTextField.snp.trailing).offset(8)
            make.height.equalTo(49)
            make.width.equalTo(92)
            make.bottom.equalToSuperview()
        }

        explainLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        explainTextView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(8)
            make.height.equalTo(192)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        explainLengthLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(24)
        }

        regionLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        regionButton.snp.makeConstraints { make in
            make.top.equalTo(regionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 139, height: 52))
            make.bottom.equalToSuperview()
        }

        periodLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        periodStartButton.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 139, height: 52))
        }

        periodIngLabel.snp.makeConstraints { make in
            make.centerY.equalTo(periodStartButton)
            make.leading.equalTo(periodStartButton.snp.trailing).offset(8)
        }

        periodEndButton.snp.makeConstraints { make in
            make.top.equalTo(periodStartButton)
            make.leading.equalTo(periodIngLabel.snp.trailing).offset(8)
            make.size.equalTo(CGSize(width: 139, height: 52))
            make.bottom.equalToSuperview()
        }

        studyMeetingLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(studyMeetingLabel.snp.bottom).offset(18)
        }

        timeButton.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
            make.centerY.equalTo(timeLabel)
            make.size.equalTo(CGSize(width: 119, height: 36))
        }

        repeatLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(29)
        }

        repeatButton.snp.makeConstraints { make in
            make.leading.equalTo(repeatLabel.snp.trailing).offset(8)
            make.centerY.equalTo(repeatLabel)
            make.size.equalTo(CGSize(width: 119, height: 36))
            make.bottom.equalToSuperview()
        }

        studyRuleLabel.snp.makeConstraints { $0.top.leading.equalToSuperview() }

        studyRuleTextView.snp.makeConstraints { make in
            make.top.equalTo(studyRuleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(192)
            make.bottom.equalToSuperview()
        }
        
        studyRuleLengthLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(24)
        }

        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(72)
        }
    }

    
    // MARK: - Bind
    
    override func bind() {
        let input = CreateStudyGroupViewModel.Input(
            didTapFieldButton: fieldButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.goToSelectStudyGroupFieldVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.navigateToSelectStudyGroupFieldVC)
            .store(in: &cancellables)
    }
}

// MARK: - Configure Component

extension CreateStudyGroupViewController {
    private static func createEssentialLabel(text: String) -> UILabel {
        let label = UILabel().setLabelProperty(text: text, font: StumeetFont.bodysemibold.font, color: .gray800)
        label.setColorAndFont(to: "*", withColor: StumeetColor.primary700.color, withFont: StumeetFont.bodysemibold.font)
        return label
    }
    
    private static func createConfigButton(title: String, image: UIImage, radius: CGFloat) -> UIButton {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.imagePadding = 6
        
        var titleAttributes = AttributedString(title)
        titleAttributes.font = StumeetFont.bodyMedium14.font
        titleAttributes.foregroundColor = StumeetColor.gray400.color
        config.attributedTitle = titleAttributes
        
        button.configuration = config
        
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.gray75.color.cgColor
        button.layer.cornerRadius = radius
        
        return button
    }
    
    private static func createTextView(placeholder: String) -> UITextView {
        let textView = UITextView()
        textView.text = placeholder
        textView.textColor = StumeetColor.gray300.color
        textView.font = StumeetFont.bodyMedium14.font
        textView.isScrollEnabled = false
        textView.backgroundColor = StumeetColor.primary50.color
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        textView.layer.cornerRadius = 16
            
        return textView
    }
}
