//
//  SnsLoginViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import UIKit
import Combine
import SnapKit

class SnsLoginViewController: BaseViewController {
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .Onboarding.onboardingImg4)
        return imageView
    }()
    
    private let titleLabelContainer: UIView = {
        let view =  UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스터밋 시작하기"
        label.textAlignment = .center
        label.font = StumeetFont.headingSemibold.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        return label
    }()
    
    private let buttonHStackViewContainer: UIView = {
        let view =  UIView()
        return view
    }()
    
    private let buttonHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing =  16
        return stackView
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(resource: .Onboarding.kakaoButton), for: .normal)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(resource: .Onboarding.appleidButton), for: .normal)
        return button
    }()
    
    // MARK: - Properties
    private weak var coordinator: AuthNavigation!
    private let viewModel: SnsLoginViewModel
    
    // MARK: - Init
    init(viewModel: SnsLoginViewModel,
         coordinator: AuthNavigation
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    override func setupAddView() {
        view.addSubview(rootVStackView)
        
        titleLabelContainer.addSubview(titleLabel)
        buttonHStackViewContainer.addSubview(buttonHStackView)
        
        [
            kakaoLoginButton,
            appleLoginButton
        ].forEach { buttonHStackView.addArrangedSubview($0) }
        
        [
            imageView,
            titleLabelContainer,
            buttonHStackViewContainer
        ].forEach { rootVStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(46)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        buttonHStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(79)
        }
        
        [
            kakaoLoginButton,
            appleLoginButton
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(64)
            }
        }
    }
    
    override func bind() {
        
        let loginTapPublisher = Publishers.Merge(
            appleLoginButton.tapPublisher
                .map { LoginType.apple }
                .eraseToAnyPublisher(),
            kakaoLoginButton.tapPublisher
                .map { LoginType.kakao }
                .eraseToAnyPublisher()
        ).eraseToAnyPublisher()
        
            
        // MARK: - Input
        let input = SnsLoginViewModel.Input(
            loginType: loginTapPublisher
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.authStateNavigation
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .loginSuccess:
                    coordinator.goToHomeVC()
                case .signUp:
                    coordinator.goToRegisterVC()
                case .none:
                    return
                }
            }
            .store(in: &cancellables)
        
        output.showError
            .receive(on: RunLoop.main)
            .sink { errorMessage in
                // TODO: 에러 관련 로직
                print(errorMessage)
            }
            .store(in: &cancellables)
    }
}
