//
//  SnsLoginViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import UIKit
import Combine

class SnsLoginViewController: BaseViewController {
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "changeProfileCharacter")
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
        button.backgroundColor = .yellow
        button.setTitle("카카오", for: .normal)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("애플", for: .normal)
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
        self.view.backgroundColor = .white
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
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.3463)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        buttonHStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
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
            .sink { [weak self] isLoggedIn in
                guard let self = self else { return }

                if isLoggedIn {
                    coordinator.goToHomeVC()                    
                } else {
                    coordinator.goToRegisterVC()
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
