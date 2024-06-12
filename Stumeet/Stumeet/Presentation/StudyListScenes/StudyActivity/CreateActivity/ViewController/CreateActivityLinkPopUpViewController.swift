//
//  CreateActivityLinkPopUpViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/7/24.
//

import UIKit

protocol CreateActivityLinkDelegate: AnyObject {
    func didTapRegisterButton(link: String)
}

final class CreateActivityLinkPopUpViewController: BaseViewController {

    // MARK: - UIComponents
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    private let hyperLinkLabel: UILabel = {
        return UILabel().setLabelProperty(text: "하이퍼링크", font: StumeetFont.subTitleMedium2.font, color: .gray800)
    }()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark).withTintColor(StumeetColor.gray800.color), for: .normal)
        
        return button
    }()
    
    private let linkTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "링크를 입력하세요..."
        textField.setPlaceholder(font: .bodyMedium14, color: .gray400)
        textField.layer.cornerRadius = 16
        textField.backgroundColor = StumeetColor.gray75.color
        textField.addLeftPadding(24)
        
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = StumeetColor.gray200.color
        button.layer.cornerRadius = 24
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: CreateActivityLinkPopUpViewModel
    private let coordinator: CreateActivityNavigation
    weak var delegate: CreateActivityLinkDelegate?
    
    // MARK: - Init
    
    init(viewModel: CreateActivityLinkPopUpViewModel, coordinator: CreateActivityNavigation) {
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
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    override func setupAddView() {
        [
            hyperLinkLabel,
            xButton,
            linkTextField,
            registerButton
        ]   .forEach(containerView.addSubview)
        
        [
            containerView
        ]   .forEach(view.addSubview)
        
    }
    
    override func setupConstaints() {
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(225)
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        hyperLinkLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(24)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(24)
        }
        
        linkTextField.snp.makeConstraints { make in
            make.top.equalTo(hyperLinkLabel.snp.bottom).offset(26)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(49)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        
        let input = CreateActivityLinkPopUpViewModel.Input(
            didBegienEditing: linkTextField.didBeginEditingPublisher,
            didChangedText: linkTextField.textPublisher,
            didTapXButton: xButton.tapPublisher,
            didTapRegisterButton: registerButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isEnableRegisterButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateRegisterButton)
            .store(in: &cancellables)
        
        output.registerLink
            .receive(on: RunLoop.main)
            .sink { [weak self] link in
                self?.delegate?.didTapRegisterButton(link: link)
                self?.coordinator.dismiss()
            }
            .store(in: &cancellables)
        
        output.updateConstraintContainerView
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateConstraintContainerView)
            .store(in: &cancellables)
        
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.dismiss)
            .store(in: &cancellables)
    }
}

// MARK: - UpdateUI

extension CreateActivityLinkPopUpViewController {
    private func updateRegisterButton(isEnable: Bool) {
        registerButton.isEnabled = isEnable
        registerButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
    }
    
    private func updateConstraintContainerView() {
        containerView.snp.remakeConstraints { make in
            make.height.equalTo(225)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-32)
        }
    }
}
