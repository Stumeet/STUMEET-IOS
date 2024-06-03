//
//  CreateActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/18/24.
//

import Combine
import UIKit

final class CreateActivityViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let topLabel: UILabel = {
        return UILabel().setLabelProperty(text: "활동 생성", font: StumeetFont.titleMedium.font, color: nil)
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .normal)
        
        return button
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.attributedTitle = AttributedString("자유")
        config.image = UIImage(named: "greenDownPolygon")
        config.imagePlacement = .trailing
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        
        return button
    }()
    
    private lazy var categoryStackViewContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = StumeetColor.gray75.color.cgColor
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.layer.masksToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        containerView.addSubview(stackView)
        containerView.isHidden = true
        
        return containerView
    }()
    
    private lazy var freedomButton: UIButton = createCategoryItemButton(category: .freedom)
    private lazy var meetingButton: UIButton = createCategoryItemButton(category: .meeting)
    private lazy var homeWorkButton: UIButton = createCategoryItemButton(category: .homework)
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 이름"
        textField.setPlaceholder(font: .subTitleMedium2, color: .gray600)
        
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력하세요"
        textView.textColor = StumeetColor.gray300.color
        textView.font = StumeetFont.bodyMedium15.font
        
        return textView
        
    }()
    
    private let bottomView = UIView()
    
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addImageButton"), for: .normal)
        
        return button
    }()
    
    private let noticeLabel: UILabel = {
        return UILabel().setLabelProperty(text: "공지 등록", font: StumeetFont.bodyMedium14.font, color: .gray500)
    }()
    
    private let noticeSwitch = UISwitch()
    
    // MARK: - Properties
    
    private let viewModel: CreateActivityViewModel
    private let coordinator: CreateActivityNavigation
    
    // MARK: - Init
    
    init(viewModel: CreateActivityViewModel, coordinator: CreateActivityNavigation) {
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
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - SetUp
    
    override func viewDidLayoutSubviews() {
        bottomView.layer.addBorder([.top, .bottom], color: StumeetColor.gray100.color, width: 1)
        
        contentTextView.layer.addBorder([.top], color: StumeetColor.gray100.color, width: 1)
        categoryStackViewContainer.layer.addBorder([.left, .right, .bottom], color: StumeetColor.gray100.color, width: 1)
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        noticeSwitch.transform = CGAffineTransform(scaleX: 36 / 51, y: 20 / 31)
        let buttonWidth = UIScreen.main.bounds.width - 32
        categoryButton.configuration?.imagePadding =  269 * buttonWidth / 380
    }
    
    override func setupAddView() {
        
        let stackView = categoryStackViewContainer.subviews.first as? UIStackView
        
        [
            freedomButton,
            meetingButton,
            homeWorkButton
        ]   .forEach { stackView?.addArrangedSubview($0) }
        
        [
            imageButton,
            noticeLabel,
            noticeSwitch
        ]   .forEach { bottomView.addSubview($0) }
        
        [
            xButton,
            topLabel,
            nextButton,
            titleTextField,
            contentTextView,
            categoryStackViewContainer,
            categoryButton,
            bottomView
        ]   .forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
    }
    
    override func setupConstaints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        topLabel.snp.makeConstraints { make in
            make.leading.equalTo(xButton.snp.trailing).offset(24)
            make.top.equalTo(xButton)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(topLabel)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(520)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(64)
        }
        
        imageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        noticeSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(noticeSwitch.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        categoryStackViewContainer.snp.makeConstraints { make in
            make.height.equalTo(168)
            make.top.equalTo(categoryButton.snp.bottom).offset(-8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        categoryStackViewContainer.subviews[0].snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        
        // MARK: - Input
        
        let categoryButtonTaps = Publishers.Merge3(
            freedomButton.tapPublisher.map { ActivityCategory.freedom },
            meetingButton.tapPublisher.map { ActivityCategory.meeting },
            homeWorkButton.tapPublisher.map { ActivityCategory.homework })
        
        let input = CreateActivityViewModel.Input(
            didChangeTitle: titleTextField.textPublisher,
            didChangeContent: contentTextView.textPublisher,
            didBeginEditing: contentTextView.didBeginEditingPublisher,
            didTapCategoryButton: categoryButton.tapPublisher,
            didTapCategoryItem: categoryButtonTaps.eraseToAnyPublisher(),
            didTapXButton: xButton.tapPublisher,
            didTapNextButton: nextButton.tapPublisher
        )
        
        // MARK: - Output
        
        let output = viewModel.transform(input: input)
        
        // textview placeholder 지우기
        output.isBeginEditing
            .filter { $0 }
            .removeDuplicates()
            .map { _ in }
            .receive(on: RunLoop.main)
            .sink(receiveValue: setBeginEditingText)
            .store(in: &cancellables)
        
        // 다음 버튼 enable 설정
        output.isEnableNextButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: checkNavigateToSettingVC)
            .store(in: &cancellables)
        
        // 카테고리 스택뷰 업데이트
        output.isHiddenCategoryItems
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCategoryItem)
            .store(in: &cancellables)
        
        // 선택한 category UI binding
        output.selectedCategory
            .receive(on: RunLoop.main)
            .assign(to: \.configuration!.attributedTitle, on: categoryButton)
            .store(in: &cancellables)
        
        // 500자 이상일 경우 SnackBar 표시
        output.maxLengthText
            .filter { $0 != "" }
            .receive(on: RunLoop.main)
            .sink(receiveValue: showMaxLengthContentSnackBar)
            .store(in: &cancellables)
        
        // dismiss
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.dismiss)
            .store(in: &cancellables)
    }
}


// MARK: UpdateUI

extension CreateActivityViewController {
    
    private func createCategoryItemButton(category: ActivityCategory) -> UIButton {
        
        var config = UIButton.Configuration.plain()
        config.title = category.title
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22.8, bottom: 0, trailing: 0)
        
        if case .freedom = category {
            config.baseForegroundColor = StumeetColor.primary700.color
        } else { config.baseForegroundColor = StumeetColor.gray400.color}

        let button = UIButton()
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        return button
    }
    
    private func updateCategoryItem(isHidden: Bool) {
        
        let categoryButtons: [ActivityCategory: UIButton?] = [
            .freedom: freedomButton,
            .meeting: meetingButton,
            .homework: homeWorkButton
        ]
        
        categoryStackViewContainer.isHidden = isHidden
        if isHidden {
            let selectedCategory = viewModel.currentCategorySubject.value
            categoryButtons.forEach { category, button in
                if category == selectedCategory {
                    button?.configuration?.baseForegroundColor = StumeetColor.primary700.color
                } else {
                    button?.configuration?.baseForegroundColor = .black
                }
            }
        }
    }
    
    private func checkNavigateToSettingVC(isEnable: Bool) {
        if isEnable { coordinator.goToStudyActivitySettingVC() }
        else { showSnackBar(text: "! 활동 작성이 완료되지 않았어요.") }
    }
    
    private func showSnackBar(text: String) {
        let snackBar = SnackBar(frame: .zero, text: text)
        
        view.addSubview(snackBar)
        
        snackBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.bottomView.snp.top).offset(-24)
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
    
    private func showMaxLengthContentSnackBar(text: String) {
        contentTextView.text = String(contentTextView.text?.dropLast() ?? "")
        showSnackBar(text: text)
    }
    
    private func setBeginEditingText() {
        contentTextView.text = ""
        contentTextView.textColor = StumeetColor.gray800.color
    }
}
