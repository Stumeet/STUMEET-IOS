//
//  ChangeProfileViewController.swift.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import UIKit

class ChangeProfileViewController: BaseViewController {
    
    // MARK: - UIComponets
    
    private lazy var progressBar: UIView = {
        let view = UIView().makeProgressBar(percent: 0.2)
        
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "프로필 사진을 설정해주세요",
            font: StumeetFont.titleMedium.font,
            color: nil)
        
        return label
    }()
    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)
        button.setImage(UIImage(named: "changeProfileCharacter"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 90
        
        return button
    }()
    
    private lazy var changeImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)
        button.setImage(UIImage(named: "changeProfileButton"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 32
        
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음")
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LfieCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBarItems()
    }
    
    // MARK: - SetUP
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        
        [
            progressBar,
            titleLabel,
            profileImageButton,
            changeImageButton,
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
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(36)
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
    
    func configureNavigationBarItems() {
        
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backButton"),
            style: .plain,
            target: self,
            action: nil
        )
        backButton.tintColor = .black
        
        let titleLabel = UILabel().setLabelProperty(
            text: "프로필 설정",
            font: StumeetFont.titleMedium.font,
            color: nil
        )
        
        let navigationTitleItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItems = [backButton, navigationTitleItem]
    }
}


// MARK: Objc Function

extension ChangeProfileViewController {
    
    @objc private func didTapNextButton(_ sender: UIButton) {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    @objc private func didTapImageButton(_ sender: UIButton) {
        
    }
}
