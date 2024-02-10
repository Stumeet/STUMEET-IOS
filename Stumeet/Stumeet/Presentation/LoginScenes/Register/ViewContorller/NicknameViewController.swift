//
//  NicknameViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

class NicknameViewController: BaseViewController {

    // MARK: - UIComponents
    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "닉네임을 입력해주세요",
            font: .boldSystemFont(ofSize: 24),
            color: nil
        )
        
        return label
    }()
    
    let nicknameTextFiled: UITextField = {
        let textField = UITextField()
        textField.placeholder = "영어 대/소문자, 한글 10글자 이내"
        textField.font = .systemFont(ofSize: 16)
        textField.addLeftPadding(24)
        textField.backgroundColor = StumeetColor.gray75.color
        textField.layer.cornerRadius = 16
        
        return textField
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "0/10",
            font: .systemFont(ofSize: 16),
            color: .gray100
        )
        
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "우와 멋진 닉네임이에요!",
            font: .systemFont(ofSize: 16),
            color: StumeetColor.success
        )
        
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음")
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Setup
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        
        nicknameTextFiled.addSubview(textCountLabel)
        
        [
            titleLabel,
            nicknameTextFiled,
            captionLabel,
            nextButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        nicknameTextFiled.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.height.equalTo(72)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFiled.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }

}

extension NicknameViewController {
    
    @objc func didTapNextButton(_ sender: UIButton) {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
}
    
