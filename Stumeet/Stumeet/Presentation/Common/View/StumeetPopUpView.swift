//
//  StumeetPopUpView.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

/// Stumeet Custom 기본 PopUpView입니다.
final class StumeetPopUpView: UIView {
    
    // MARK: - UIComponents
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.backgroundColor = .white
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.titleBold.font, color: .gray800)
    }()
    
    private let subTitleLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.titleMedium.font, color: .gray800)
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        button.layer.cornerRadius = 24
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(StumeetColor.primary700.color, for: .normal)
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        
        return button
    }()
    
    // MARK: - Subject
    
    let leftButtonTapSubject = PassthroughSubject<Void, Never>()
    let rightButtonTapSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStyle()
        setUpAddView()
        setUpConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp
    
    private func setUpStyle() {
        backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    private func setUpAddView() {
        [
            titleLabel,
            subTitleLabel,
            leftButton,
            rightButton
        ]   .forEach(containerView.addSubview)
        
        [
            containerView
        ]   .forEach(addSubview)
        
    }
    
    private func setUpConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(192)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(44)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        
        leftButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(72)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(72)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [
            leftButton,
            rightButton
        ]   .forEach {
            $0.snp.updateConstraints { make in
                make.width.equalTo(containerView.frame.width / 2)
            }
        }
    }
    
    func configurePopUpView(item: PopUp) {
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
        leftButton.setTitle(item.leftButtonTitle, for: .normal)
        rightButton.setTitle(item.rightButtonTitle, for: .normal)
    }
    
    func bind() {
        leftButton.tapPublisher
            .sink(receiveValue:leftButtonTapSubject.send)
            .store(in: &cancellables)
        
        rightButton.tapPublisher
            .sink(receiveValue: rightButtonTapSubject.send)
            .store(in: &cancellables)
    }
}
