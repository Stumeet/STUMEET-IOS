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
    
    private lazy var startDateButton: UIButton = {
        return createActivitySettingButton(title: "시작 일시", subTitle: "test", subTitleColor: .primary700)
    }()
    
    private lazy var endDateButton: UIButton = {
        return createActivitySettingButton(title: "종료 일시", subTitle: "test", subTitleColor: .primary700)
    }()
    
    private lazy var placeButton: UIButton = {
        return createActivitySettingButton(title: "장소", subTitle: "장소를 선택해주세요", subTitleColor: .gray300)
    }()
    
    private lazy var memberButton: UIButton = {
        return createActivitySettingButton(title: "멤버", subTitle: "멤버를 선택해주세요", subTitleColor: .gray300)
    }()
    
    private lazy var postButton: UIButton = {
        return UIButton().makeRegisterBottomButton(text: "게시", color: StumeetColor.gray200.color)
    }()
    
    // MARK: - Properties
    private let viewModel: StudyActivitySettingViewModel
    
    // MARK: - Init
    
    init() {
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
            make.leading.trailing.equalTo(16)
            make.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
    }
}

extension StudyActivitySettingViewController {
    func createActivitySettingButton(title: String, subTitle: String, subTitleColor: StumeetColor) -> UIButton {
        let button = UIButton()
        
        let titleLabel = UILabel().setLabelProperty(text: title, font: StumeetFont.bodyMedium16.font, color: nil)
        let subTitleLabel = UILabel().setLabelProperty(text: subTitle, font: StumeetFont.bodyMedium15.font, color: subTitleColor)
        
        button.addSubview(titleLabel)
        button.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        return button
    }
}
