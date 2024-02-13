//
//  ChangeProfileViewController.swift.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import UIKit

class ChangeProfileViewController: BaseViewController {
    
    // TODO: - icon image, titleLabel 속성, vertiaclLine, navigation title
    
    // MARK: - UIComponets

    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "프로필 사진을 설정해주세요",
            font: .boldSystemFont(ofSize: 24),
            color: nil)
        
        return label
    }()
    
    lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 90
        
        return button
    }()
    
    lazy var changeImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)
        button.backgroundColor = .systemPink
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 32
        
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음")
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LfieCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUP
    
    // TODO: - navigationbar 커스텀
    
    override func setupStyles() {
        view.backgroundColor = .white
        navigationItem.title = "로그인"
    }
    
    override func setupAddView() {
        
        [
            titleLabel,
            profileImageButton,
            changeImageButton,
            nextButton
        ]   .forEach { view.addSubview($0) }
        
        
    }
    
    override func setupConstaints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.width.height.equalTo(180)
        }
        
        changeImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageButton.snp.trailing)
            make.bottom.equalTo(profileImageButton.snp.bottom)
            make.width.height.equalTo(64)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
}


// MARK: Objc Function

extension ChangeProfileViewController {
    
    @objc func didTapNextButton(_ sender: UIButton) {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    @objc func didTapImageButton(_ sender: UIButton) {
        
    }
}
