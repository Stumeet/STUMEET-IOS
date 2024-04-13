//
//  NicknameViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import Combine
import UIKit


class NicknameViewController: BaseViewController {

    // MARK: - UIComponents
    
    private lazy var progressBar: UIView = {
        let view = UIView().makeProgressBar(percent: 0.4)
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "닉네임을 입력해주세요",
            font: StumeetFont.titleMedium.font,
            color: nil
        )
        
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "영어 대/소문자, 한글 10글자 이내"
        textField.font = StumeetFont.bodyMedium16.font
        textField.addLeftPadding(24)
        textField.backgroundColor = StumeetColor.gray75.color
        textField.layer.cornerRadius = 16
        
        return textField
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "0/10",
            font: StumeetFont.bodyMedium16.font,
            color: .gray100
        )
        
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "우와 멋진 닉네임이에요!",
            font: StumeetFont.bodyMedium16.font,
            color: nil
        )
        
        label.isHidden = true
        
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음", color: StumeetColor.gray200.color)

        return button
    }()
    
    // MARK: - Properties
    
    private weak var coordinator: RegisterNavigation!
    private let viewModel: NicknameViewModel
    
    // MARK: - Init
    
    init(viewModel: NicknameViewModel, coordinator: RegisterNavigation) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRegisterNavigationBarItems()
    }
    
    
    // MARK: - Setup
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        
        nicknameTextField.addSubview(textCountLabel)
        
        [
            progressBar,
            titleLabel,
            nicknameTextField,
            captionLabel,
            nextButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.height.equalTo(56)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        
        // MARK: - Input
        
        let input = NicknameViewModel.Input(
            changeText: nicknameTextField
                .textPublisher.compactMap { $0 }
                .eraseToAnyPublisher(),
            didTapNextButton: nextButton.tapPublisher
        )
    
        // MARK: - Output
        
        let output = viewModel.transform(input: input)
    
        // 중복에따른 캡션 변경
        output.isDuplicate
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] isDuplicate in
                self?.captionLabel.textColor = isDuplicate ? StumeetColor.warning500.color : StumeetColor.success.color
                self?.nicknameTextField.backgroundColor = isDuplicate ? StumeetColor.warning50.color : StumeetColor.primary50.color
                self?.captionLabel.text = isDuplicate ? "이미 사용중인 닉네임이에요" : "우와, 멋진 닉네임이에요!"
            }
            .store(in: &cancellables)
        
        // 다음 버튼 Enable 업데이트
        output.isNextButtonEnable
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnable in
                self?.nextButton.backgroundColor = isEnable ? StumeetColor.primaryInfo.color : StumeetColor.gray200.color
                self?.nextButton.isEnabled = isEnable
            }
            .store(in: &cancellables)
        
        // count label 업데이트
        output.count
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.captionLabel.isHidden = count == 0
                self?.textCountLabel.isHidden = count == 0
                self?.textCountLabel.text = "\(count)/10"
            }
            .store(in: &cancellables)
        
        // 10보다 클 경우 입력 제한
        output.isBiggerThanTen
            .receive(on: RunLoop.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.nicknameTextField.text = String(self?.nicknameTextField.text?.dropLast() ?? "")
            }
            .store(in: &cancellables)
        
        // 지역 선택VC로 push
        output.navigateToSelectRegionVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.goToSelectRegionVC)
//            .sink(receiveValue: { [weak self] data in self?.coordinator.goToSelectRegionVC(register: data)})
            .store(in: &cancellables)
    }
}
