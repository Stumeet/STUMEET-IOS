//
//  NicknameViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import Combine
import UIKit

import CombineCocoa


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
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "영어 대/소문자, 한글 10글자 이내"
        textField.font = StumeetFont.bodyMedium16.font
        textField.addLeftPadding(24)
        textField.backgroundColor = StumeetColor.gray75.color
        textField.layer.cornerRadius = 16
        
        return textField
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "0/10",
            font: StumeetFont.bodyMedium16.font,
            color: .gray100
        )
        
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "우와 멋진 닉네임이에요!",
            font: StumeetFont.bodyMedium16.font,
            color: nil
        )
        
        label.isHidden = true
        
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음", color: StumeetColor.gray200.color)

        return button
    }()
    
    // MARK: - Properties
    let coordinator: RegisterCoordinator
    let viewModel: NicknameViewModel
    
    // MARK: - Init
    init(viewModel: NicknameViewModel, coordinator: RegisterCoordinator) {
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
        
        // Input
        
        let input = NicknameViewModel.Input(
            changeText: nicknameTextField
                .textPublisher.compactMap { $0 }
                .eraseToAnyPublisher(),
            didTapNextButton: nextButton.tapPublisher
            
        )
    
        // Output
        
        let output = viewModel.transform(input: input)
    
        output.isDuplicate
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] isDuplicate in
                if isDuplicate {
                    self?.captionLabel.textColor = StumeetColor.warning500.color
                    self?.nicknameTextField.backgroundColor = StumeetColor.warning50.color
                    self?.captionLabel.text = "이미 사용중인 닉네임이에요"
                } else {
                    self?.captionLabel.textColor = StumeetColor.success.color
                    self?.nicknameTextField.backgroundColor = StumeetColor.primary50.color
                    self?.captionLabel.text = "우와, 멋진 닉네임이에요!"
                }
            }
            .store(in: &cancellables)
        
        output.isNextButtonEnable
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnable in
                self?.nextButton.backgroundColor = isEnable ? StumeetColor.primaryInfo.color : StumeetColor.gray200.color
                self?.nextButton.isEnabled = isEnable
            }
            .store(in: &cancellables)
        
        output.count
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.captionLabel.isHidden = count == 0
                self?.textCountLabel.isHidden = count == 0
                self?.textCountLabel.text = "\(count)/10"
            }
            .store(in: &cancellables)
        
        output.isBiggerThanTen
            .receive(on: RunLoop.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.nicknameTextField.text = String(self?.nicknameTextField.text?.dropLast() ?? "")
            }
            .store(in: &cancellables)
        
        output.navigateToSelectRegionVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.navigateToSelectRegionVC)
            .store(in: &cancellables)
    }
}
