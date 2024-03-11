//
//  StartViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import UIKit

import CombineCocoa

class StartViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(text: "스터밋에 오신걸 환영해요!", font: StumeetFont.headingBold.font, color: nil)
        
        let attributeString = NSMutableAttributedString(string: label.text!)
        attributeString.addAttribute(
            .foregroundColor,
            value: StumeetColor.primaryInfo.color,
            range: NSRange(location: 0, length: 3)
        )
        label.attributedText = attributeString
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "changeProfileCharacter")
        
        return imageView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(StumeetColor.gray50.color, for: .normal)
        button.backgroundColor = StumeetColor.primaryInfo.color
        button.layer.cornerRadius = 16
    
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: StartViewModel
    private let coordinator: RegisterCoordinator
    
    // MARK: - Init
    
    init(viewModel: StartViewModel, coordinator: RegisterCoordinator) {
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
            titleLabel,
            imageView,
            startButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(140)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(362)
            make.height.equalTo(300)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(72)
        }
        
    }
    
    override func bind() {
        let input = StartViewModel.Input(
            didTapStartButton: startButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isNaviteToTabBar
            .receive(on: RunLoop.main)
            .map { _ in}
            .sink(receiveValue: coordinator.presentToTabBar)
            .store(in: &cancellables)
    }
    
}
