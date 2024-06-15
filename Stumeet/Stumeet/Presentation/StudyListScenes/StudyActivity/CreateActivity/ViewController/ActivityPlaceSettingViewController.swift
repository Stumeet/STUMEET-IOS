//
//  ActivityPlaceSettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/15/24.
//

import UIKit

protocol CreateActivityPlaceDelegate: AnyObject {
    func didTapCompleteButton(place: String)
}

class ActivityPlaceSettingViewController: BaseViewController {

    
    // MARK: - UIComponents
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: "장소", font: StumeetFont.titleMedium.font, color: .gray800)
    }()
    
    private let placeTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "장소명, 링크, 장소 별칭 등을 입력하세요"
        textField.setPlaceholder(font: .bodyMedium14, color: .gray400)
        textField.addLeftPadding(24)
        textField.layer.cornerRadius = 16
        textField.backgroundColor = StumeetColor.primary50.color
        
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: ActivityPlaceSettingViewModel
    private let coordinator: CreateActivityNavigation
    weak var delegate: CreateActivityPlaceDelegate?
    
    // MARK: - Init
    
    init(viewModel: ActivityPlaceSettingViewModel, coordinator: CreateActivityNavigation) {
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
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            xButton,
            titleLabel,
            placeTextfield,
            completeButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.centerY.equalTo(xButton)
        }
        
        placeTextfield.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = ActivityPlaceSettingViewModel.Input(
            didchangeText: placeTextfield.textPublisher,
            didTapCompleteButton: completeButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateEnableCompleteButton)
            .store(in: &cancellables)
        
        output.dismiss
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: delegate?.didTapCompleteButton)
            .map { _ in }
            .sink(receiveValue: coordinator.dismiss)
            .store(in: &cancellables)
    }

}

// MARK: - UIUpdate

extension ActivityPlaceSettingViewController {
    func updateEnableCompleteButton(isEnable: Bool) {
        completeButton.isEnabled = isEnable
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
    }
}
