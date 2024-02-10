//
//  LoginViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import UIKit

class LoginViewController: BaseViewController {
    
    // TODO: - icon image, titleLabel 속성, vertiaclLine, navigation title
    
    // MARK: - UIComponets

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 26)
        label.text =
                    """
                    스터밋과 함께하는 
                    슬기로운 공부생활!
                    """
        label.numberOfLines = 2
        
        let attributeString = NSMutableAttributedString(string: label.text!)
        attributeString.addAttribute(.foregroundColor, value: StumeetColor.primaryInfo.color, range: NSRange(location: 0, length: 3))
        label.attributedText = attributeString
        
        return label
    }()
    
    var emailView: UIView = {
        let view = UIView()
        
        view.backgroundColor = StumeetColor.gray75.color
        view.layer.cornerRadius = 16
        return view
    }()
    
    var emailImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .black
        return imageView
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "이메일"
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = StumeetColor.gray400.color
        return textField
    }()
    
    var passwordlView: UIView = {
        let view = UIView()
        
        view.backgroundColor = StumeetColor.gray75.color
        view.layer.cornerRadius = 16
        return view
    }()
    
    var passwordImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .black
        return imageView
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "비밀번호"
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = StumeetColor.gray400.color
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(StumeetColor.gray50.color, for: .normal)
        button.backgroundColor = StumeetColor.primaryInfo.color
        
        button.layer.cornerRadius = 16
        return button
    }()
    
    var registerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }()
    
    var findPassWordButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(StumeetColor.gray200.color, for: .normal)
        return button
    }()
    
    var verticalLineLabel: UILabel = {
        let label = UILabel()
        
        label.text = "|"
        label.textColor = StumeetColor.gray200.color
        return label
    }()
    
    var registerButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(StumeetColor.gray200.color, for: .normal)
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
            findPassWordButton,
            verticalLineLabel,
            registerButton
        ]   .forEach { registerStackView.addArrangedSubview($0) }
        
        
        [
            emailImageView,
            emailTextField
        ]   .forEach { emailView.addSubview($0) }
        
        [
            passwordImageView,
            passwordTextField
        ]   .forEach { passwordlView.addSubview($0) }
        
        
        [
            titleLabel,
            emailView,
            passwordlView,
            loginButton,
            registerStackView
        ]   .forEach { view.addSubview($0) }
        
        
    }
    
    override func setupConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
        }
        
        emailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.height.equalTo(72)
        }
        
        emailImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        passwordlView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(emailView.snp.bottom).offset(16)
            make.height.equalTo(72)
        }
        
        passwordImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(passwordImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(passwordlView.snp.bottom).offset(24)
            make.height.equalTo(72)
        }
        
        registerStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(24)
        }
    }
    
    override func bind() {
        
        // TODO: ViewModel과 Binding, Coordinator패턴 도입
    }
}


// MARK: Objc Function

extension LoginViewController {
    @objc func didTapLoginButton(_ sender: UIButton) {
        present(StartViewController(), animated: true)
    }
}
