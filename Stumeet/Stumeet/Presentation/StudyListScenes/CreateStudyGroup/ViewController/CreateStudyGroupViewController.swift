//
//  CreateStudyGroupViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 7/24/24.
//

import Combine
import UIKit
import PhotosUI

final class CreateStudyGroupViewController: BaseViewController {

    typealias Section = CreateStudyTagSection
    typealias SectionItem = CreateStudyTagSectionItem
    
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
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = StumeetColor.random.color
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let randomColorButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
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
    private let studyNameTextFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        view.layer.cornerRadius = 16
        
        return view
    }()
    private let studyNameTextField: UITextField = {
        let textField = UITextField()
        textField.addLeftPadding(24)
        textField.placeholder = "스터디 이름을 입력해주세요."
        textField.setPlaceholder(font: .bodyMedium14, color: .gray400)
        
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
        textField.placeholder = "태그를 직접 입력해주세요.(최대 5개)"
        textField.setPlaceholder(font: .bodyMedium14, color: .gray400)
        textField.layer.cornerRadius = 16
        textField.backgroundColor = StumeetColor.primary50.color
        return textField
    }()
    private let tagAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = StumeetColor.gray200.color
        button.titleLabel?.font = StumeetFont.bodyMedium14.font
        button.layer.cornerRadius = 16
        
        return button
    }()
    private lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(TagCell.self)
        collectionView.isScrollEnabled = false
        
        return collectionView
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
    private let periodEndButton = createConfigButton(title: "날짜 선택", image: UIImage(resource: .calendar).withTintColor(StumeetColor.gray400.color), radius: 16)
    
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
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Subject
    
    private let fieldSubject = PassthroughSubject<SelectStudyItem, Never>()
    private let didTapTagXButtonSubject = PassthroughSubject<String, Never>()
    private let regionSubject = PassthroughSubject<SelectStudyItem, Never>()
    private let periodSubject = PassthroughSubject<(startDate: Date, endDate: Date), Never>()
    private let timeSubject = PassthroughSubject<String, Never>()
    private let selectedPhotoSubject = PassthroughSubject<URL, Never>()
    private let repeatDaysSubject = PassthroughSubject<StudyRepeatType, Never>()
    
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
        
        setUpTapGesture()
        setupKeyboardNotifications()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
        configureXButtonTitleNavigationBarItems(button: UIBarButtonItem(customView: xButton), title: "스터디 그룹 생성")
        repeatButton.configuration?.contentInsets = .init(top: 0, leading: 19.33, bottom: 0, trailing: 16)
    }
    
    override func setupAddView() {
        [   studyGroupImageView,
            addImageButton,
            randomColorButton
        ]   .forEach(imageContainerView.addSubview)
        
        [   studyNameLabel,
            studyNameTextFieldBackgroundView,
            studyNameTextField,
            studyNameLengthLabel]
            .forEach(studyNameContainerView.addSubview)
        
        [   fieldLabel,
            fieldButton
        ]   .forEach(fieldContainerView.addSubview)
        
        [   tagLabel,
            tagTextField,
            tagAddButton,
            tagCollectionView
        ]   .forEach(tagContainerView.addSubview)
        
        [   explainLabel,
            explainTextView,
            explainLengthLabel
        ]   .forEach(explainContainerView.addSubview)
        
        [   regionLabel,
            regionButton
        ]   .forEach(regionContainerView.addSubview)
        
        [   periodLabel,
            periodStartButton,
            periodIngLabel,
            periodEndButton
        ]   .forEach(periodContainerView.addSubview)
        
        [   studyMeetingLabel,
            timeLabel,
            timeButton,
            repeatLabel,
            repeatButton
        ]   .forEach(studyMeetingContainerView.addSubview)
        
        [   studyRuleLabel,
            studyRuleTextView,
            studyRuleLengthLabel
        ]   .forEach(studyRuleContainerView.addSubview)
        
        
        [   imageContainerView,
            studyNameContainerView,
            fieldContainerView,
            tagContainerView,
            explainContainerView,
            regionContainerView,
            periodContainerView,
            studyMeetingContainerView,
            studyRuleContainerView
        ]   .forEach(scrollViewVStackView.addArrangedSubview)
        
        [   scrollViewVStackView
        ]   .forEach(scrollView.addSubview)
        
        [   scrollView,
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

        studyNameTextFieldBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(studyNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(49)
        }
        
        studyNameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(studyNameLabel.snp.bottom).offset(8)
            make.height.equalTo(49)
            make.trailing.equalToSuperview().inset(76)
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
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
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
            make.height.equalTo(39)
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

    private func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            if let activeTextView = studyRuleContainerView.findFirstResponder() as? UITextView {
                let textViewFrameInScrollView = scrollView.convert(activeTextView.frame, from: activeTextView.superview)
                scrollView.scrollRectToVisible(textViewFrameInScrollView, animated: true)
            }
            
            if let activeTextView = explainContainerView.findFirstResponder() as? UITextView {
                let textViewFrameInScrollView = scrollView.convert(activeTextView.frame, from: activeTextView.superview)
                scrollView.scrollRectToVisible(textViewFrameInScrollView, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라지면 스크롤뷰의 inset을 다시 원래대로 되돌립니다.
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Bind
    
    override func bind() {
        configureDatasource()
        
        let input = CreateStudyGroupViewModel.Input(
            didTapFieldButton: fieldButton.tapPublisher,
            didSelectedField: fieldSubject.eraseToAnyPublisher(),
            didChangedTagTextField: tagTextField.textPublisher,
            didTapAddTagButton: tagAddButton.tapPublisher,
            didTapTagXButton: didTapTagXButtonSubject.eraseToAnyPublisher(),
            didTapRegionButton: regionButton.tapPublisher,
            didSelectedRegion: regionSubject.eraseToAnyPublisher(),
            didTapPeriodStartButton: periodStartButton.tapPublisher,
            didTapPeriodEndButton: periodEndButton.tapPublisher,
            didSelecetedPeriod: periodSubject.eraseToAnyPublisher(),
            didTapTimeButton: timeButton.tapPublisher,
            didSelectedTime: timeSubject.eraseToAnyPublisher(),
            didTapAddImageButton: addImageButton.tapPublisher,
            didSelectPhoto: selectedPhotoSubject.eraseToAnyPublisher(),
            didChangeStudyNameTextField: studyNameTextField.textPublisher,
            didChangeStudyExplainTextView: explainTextView.textPublisher,
            didBeginExplainEditting: explainTextView.didBeginEditingPublisher,
            didChangeStudyRuleTextView: studyRuleTextView.textPublisher,
            didBeginStudyRuleEditting: studyRuleTextView.didBeginEditingPublisher,
            didTapRepeatButton: repeatButton.tapPublisher,
            didSelectedRepeatDays: repeatDaysSubject.eraseToAnyPublisher(),
            didTapCompleteButton: completeButton.tapPublisher,
            didTapRandomColorButton: randomColorButton.tapPublisher,
            didTapXButton: xButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.goToSelectStudyGroupFieldVC
            .map { (self, $0.0, $0.1) }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.navigateToSelectStudyGroupItemVC)
            .store(in: &cancellables)
        
        output.selectedField
            .receive(on: RunLoop.main)
            .map { ($0.name, StumeetColor.primary700) }
            .sink(receiveValue: fieldButton.updateConfiguration)
            .store(in: &cancellables)
        
        output.isEnableTagAddButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateTagAddButton)
            .store(in: &cancellables)
        
        output.addedTags
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        output.isEmptyTags
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateTagCollectionViewConstraints)
            .store(in: &cancellables)
        
        output.goToSelectStudyGroupRegionVC
            .map { (self, $0.0, $0.1) }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.navigateToSelectStudyGroupItemVC)
            .store(in: &cancellables)
        
        output.selectedRegion
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateRegionButton)
            .store(in: &cancellables)
        
        output.goToSetStudyGroupPeriodVC
            .map { (self, $0) }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToSetPeriodCalendarVC)
            .store(in: &cancellables)
        
        output.periodAttributedStrings
            .receive(on: RunLoop.main)
            .sink(receiveValue: updatePeriodButton)
            .store(in: &cancellables)
        
        output.goToSelectStudyTimeVC
            .map { self }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToSelectStudyTimeVC)
            .store(in: &cancellables)
        
        output.timeAttributedString
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateTimeButton)
            .store(in: &cancellables)
        
        output.showPHPickerVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: showPHPickerVC)
            .store(in: &cancellables)
        
        output.selectedImage
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: studyGroupImageView)
            .store(in: &cancellables)
        
        output.goToSelectStudyRepeatVC
            .map { self }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToSelectStudyRepeatVC)
            .store(in: &cancellables)
        
        output.selectedRepeatDays
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateRepeatButton)
            .store(in: &cancellables)
        
        output.isBiggerThanTwenty
            .receive(on: RunLoop.main)
            .filter { $0 }
            .map { _ in String(self.studyNameTextField.text?.dropLast() ?? "") }
            .assign(to: \.text, on: studyNameTextField)
            .store(in: &cancellables)
        
        output.titleCount
            .map { "\($0)/20" }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: studyNameLengthLabel)
            .store(in: &cancellables)
        
        output.isBiggerThanHundredExplain
            .receive(on: RunLoop.main)
            .filter { $0 }
            .map { _ in String(self.explainTextView.text?.dropLast() ?? "") }
            .assign(to: \.text, on: explainTextView)
            .store(in: &cancellables)
        
        output.explainCount
            .map { "\($0)/100" }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: explainLengthLabel)
            .store(in: &cancellables)
        
        output.explainBeginText
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: explainTextView)
            .store(in: &cancellables)
        
        output.isBiggerThanHundredRule
            .receive(on: RunLoop.main)
            .filter { $0 }
            .map { _ in String(self.studyRuleTextView.text?.dropLast() ?? "") }
            .assign(to: \.text, on: explainTextView)
            .store(in: &cancellables)
        
        output.ruleCount
            .map { "\($0)/100" }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: studyRuleLengthLabel)
            .store(in: &cancellables)
        
        output.ruleBeginText
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: studyRuleTextView)
            .store(in: &cancellables)
        
        output.snackBarText
            .receive(on: RunLoop.main)
            .sink(receiveValue: checkShowSnackbarOrComplete)
            .store(in: &cancellables)
        
        output.imageViewBackgroundColor
            .receive(on: RunLoop.main)
            .assign(to: \.backgroundColor, on: studyGroupImageView)
            .store(in: &cancellables)
        
        output.randomButtonColor
            .receive(on: RunLoop.main)
            .assign(to: \.backgroundColor, on: randomColorButton)
            .store(in: &cancellables)
        
        output.dismiss
            .map { true }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.dismiss)
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
        textView.backgroundColor = StumeetColor.primary50.color
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 24)
        textView.layer.cornerRadius = 16
            
        return textView
    }
}

// MARK: - Delegate

extension CreateStudyGroupViewController: 
    SelectStudyGroupItemDelegate,
    SetStudyGroupPeriodDelegate,
    SelectStudyTimeDelegate,
    SelectStudyRepeatDelegate
{
    
    func didTapFileldCompleteButton(field: SelectStudyItem) {
        fieldSubject.send(field)
    }
    
    func didTapRegionCompleteButton(region: SelectStudyItem) {
        regionSubject.send(region)
    }
    
    func didTapCompleteButton(startDate: Date, endDate: Date) {
        periodSubject.send((startDate: startDate, endDate: endDate))
    }
    
    func didTapCompleteButton(time: String) {
        timeSubject.send(time)
    }
    
    func didTapCompleteButton(repeatType: StudyRepeatType) {
        repeatDaysSubject.send(repeatType)
    }
}

// MARK: - UIUpdate

extension CreateStudyGroupViewController {
    private func updateTagAddButton(isEnable: Bool) {
        tagAddButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
        tagAddButton.isEnabled = isEnable
    }
    
    private func updateTagCollectionViewConstraints(isEmpty: Bool) {
        if isEmpty {
            tagCollectionView.snp.updateConstraints { $0.height.equalTo(0) }
        } else {
            let contentHeight = tagCollectionView.collectionViewLayout.collectionViewContentSize.height
            tagCollectionView.snp.updateConstraints { make in
                make.height.equalTo(max(contentHeight, 33))
            }
        }
    }
    
    private func updateRegionButton(item: SelectStudyItem) {
        guard var config = regionButton.configuration else { return }
        
        config.image = config.image?.withTintColor(StumeetColor.primary700.color)
        
        var titleAttributes = AttributedString(item.name)
        titleAttributes.font = StumeetFont.bodyMedium14.font
        titleAttributes.foregroundColor = StumeetColor.primary700.color
        config.attributedTitle = titleAttributes
        regionButton.configuration = config
        regionButton.layer.borderColor = StumeetColor.primary700.color.cgColor
    }
    
    private func updatePeriodButton(start: AttributedString, end: AttributedString?) {
        let buttons = [periodStartButton, periodEndButton]
        let titles = [start, end]
        zip(buttons, titles).forEach { button, title in
            let isNilEnd = title == nil
            
            button.configuration?.baseForegroundColor = isNilEnd ? StumeetColor.gray400.color : StumeetColor.primary700.color
            button.layer.borderColor = isNilEnd ? StumeetColor.gray75.color.cgColor : StumeetColor.primary700.color.cgColor
            button.configuration?.image = isNilEnd ? UIImage(resource: .calendar).withTintColor(StumeetColor.gray400.color) : UIImage(resource: .calendar)
            button.configuration?.attributedTitle = isNilEnd ? "선택 없음" : title
            button.configuration?.attributedTitle?.font = StumeetFont.bodyMedium14.font
        }
    }
    
    private func updateTimeButton(time: AttributedString) {
        timeButton.layer.borderColor = StumeetColor.primary700.color.cgColor
        timeButton.configuration?.image = UIImage(resource: .CreateStudyGroup.clock).withTintColor(StumeetColor.primary700.color)
        timeButton.configuration?.attributedTitle = time
        timeButton.configuration?.attributedTitle?.font = StumeetFont.bodyMedium14.font
        timeButton.configuration?.baseForegroundColor = StumeetColor.primary700.color
    }
    
    private func updateRepeatButton(type: StudyRepeatType) {
        
        var config = repeatButton.configuration!
        switch type {
        case .dailiy:
            config.attributedTitle = AttributedString(type.title)
        case .weekly(let days):
            if days.count == 7 {
                config.attributedTitle = AttributedString("매일")
            } else {
                let joinedDays = days.joined(separator: ", ")
                config.attributedTitle = AttributedString(type.title + " " + joinedDays + "요일")
            }

        case .monthly(let days):
            if days.last == "마지막 날" {
                var dayNumbers = days
                dayNumbers.removeLast()  // "마지막 날"을 제거
                
                let joinedDays = dayNumbers.joined(separator: ",")
                
                if !dayNumbers.isEmpty {
                    config.attributedTitle = AttributedString("\(type.title) \(joinedDays) 일, 마지막 날")
                } else {
                    config.attributedTitle = AttributedString("\(type.title) 마지막 날")
                }
            } else {
                let joinedDays = days.joined(separator: ",")
                config.attributedTitle = AttributedString("\(type.title) \(joinedDays) 일")
            }
        }
        config.attributedTitle?.font = StumeetFont.bodyMedium14.font
        config.baseForegroundColor = StumeetColor.primary700.color
        config.image = UIImage(resource: .CreateStudyGroup.repeatButton).withTintColor(StumeetColor.primary700.color)
        repeatButton.configuration = config
        repeatButton.layer.borderColor = StumeetColor.primary700.color.cgColor
    }
    
    private func updateRandomColorButton(color: UIColor?) {
        randomColorButton.backgroundColor = color
    }
    
    private func checkShowSnackbarOrComplete(text: String) {
        print("asdf \(text)")
        if text.isEmpty {
            coordinator.dismiss(animated: true)
        } else {
            let snackBar = SnackBar(frame: .zero, text: text)
            
            view.addSubview(snackBar)
            
            snackBar.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalTo(completeButton.snp.top).offset(-24)
                make.height.equalTo(74)
            }
            
            snackBar.isHidden = false
            snackBar.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                snackBar.alpha = 1
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    UIView.animate(withDuration: 0.3) {
                        snackBar.alpha = 0
                    } completion: { _ in
                        snackBar.isHidden = true
                        snackBar.removeFromSuperview()
                    }
                }
            }
        }
    }
}

// MARK: - Datasource

extension CreateStudyGroupViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: tagCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .tagCell(let tag):
                guard let cell = collectionView.dequeue(TagCell.self, for: indexPath) else { return UICollectionViewCell() }
                cell.configureCreateStudyTagCell(tag: tag)
                
                cell.xButton.tapPublisher
                    .map { tag }
                    .sink(receiveValue: self.didTapTagXButtonSubject.send)
                    .store(in: &cell.cancellables)
                
                return cell
            }
        })
    }
    
    private func updateSnapshot(tags: [SectionItem]) {
        guard let datasource = datasource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tags)
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func showPHPickerVC() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        
        coordinator.presentPHPickerView(pickerVC: pickerVC)
    }
}

extension CreateStudyGroupViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                if let url {
                    self.selectedPhotoSubject.send(url)
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
