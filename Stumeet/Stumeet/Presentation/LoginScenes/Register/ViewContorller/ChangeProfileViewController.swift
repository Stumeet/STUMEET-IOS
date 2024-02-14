//
//  ChangeProfileViewController.swift.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import Combine
import UIKit
import PhotosUI

import CombineCocoa

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
        button.setImage(UIImage(named: "changeProfileCharacter"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 90
        
        return button
    }()
    
    private lazy var changeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "changeProfileButton"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 32
        
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음")
        
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: ChangeProfileViewModel
    private let coordinator: RegisterCoordinator
    
    // MARK: - Init
    init(viewModel: ChangeProfileViewModel, coordinator: RegisterCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LfieCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBarItems()
    }
    
    // MARK: - SetUp
    
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
    
    override func bind() {
        
        // MARK: - Input
        
        // 이미지 변경 버튼 Tap
        let changeImageButtonTapPublisher = Publishers.Merge(
            changeImageButton.tapPublisher,
            profileImageButton.tapPublisher
        ).eraseToAnyPublisher()
        
        let input = ChangeProfileViewModel
            .Input(
                didTapChangeProfileButton: changeImageButtonTapPublisher,
                didTapNextButton: nextButton.tapPublisher
            )
        
        // MARK: - Output
        
        let output = viewModel.transform(input: input)
        
        // navigate To NickNameVC
        output.pushNickNameVC
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator.navigateToNickNameVC()
            }
            .store(in: &cancellables)
        
        // present To PHPickerView
        output.showAlbum
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                
                var config = PHPickerConfiguration()
                config.filter = .images
                config.selectionLimit = 1
                let pickerVC = PHPickerViewController(configuration: config)
                pickerVC.delegate = self
                
                self?.coordinator.presentPHPickerView(pickerVC: pickerVC)
            }
            .store(in: &cancellables)
    }
}

// MARK: - PHPickerViewDelegate

extension ChangeProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
    }
}
