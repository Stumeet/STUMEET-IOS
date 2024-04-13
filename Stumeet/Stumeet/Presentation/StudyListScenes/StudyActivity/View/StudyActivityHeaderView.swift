//
//  StudyActivityHeaderView.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import Combine
import UIKit

class StudyActivityHeaderView: BaseCollectionReusableView {
    
    // MARK: - Identifier
    
    static let identifier = "StudyActivityHeaderView"
    
    // MARK: - UIComponents
    
    let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel().setLabelProperty(text: "활동", font: StumeetFont.titleMedium.font, color: .gray800)
        return label
    }()
    
    let allButton: UIButton = {
        let button = makeHeaderButton(title: "전체")
        button.isSelected = true
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        
        return button
    }()
    
    let groupButton: UIButton = {
        let button = makeHeaderButton(title: "모임")
        button.titleLabel?.font = StumeetFont.titleMedium.font
        button.sizeToFit()
        return button
    }()
    
    let taskButton: UIButton = {
        let button = makeHeaderButton(title: "과제")
        button.titleLabel?.font = StumeetFont.titleMedium.font
        
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        return stackView
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        
        var titleAttr = AttributedString.init("최신순")
        titleAttr.font = StumeetFont.bodyMedium14.font
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.imagePlacement = .trailing
        config.image = UIImage(systemName: "chevron.down")
        config.baseBackgroundColor = .white
        config.baseForegroundColor = StumeetColor.gray300.color
        button.configuration = config
        
        return button
    }()
    
    // MARK: - Property
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Override
    
    override func prepareForReuse() {
        cancellables = Set<AnyCancellable>()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            allButton,
            groupButton,
            taskButton
        ]   .forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            xButton,
            topLabel,
            buttonStackView,
            sortButton
        ]   .forEach { addSubview($0) }
    }
    
    override func setupConstaints() {
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
            make.width.height.equalTo(24)
        }
        
        topLabel.snp.makeConstraints { make in
            make.leading.equalTo(xButton.snp.trailing).offset(24)
            make.centerY.equalTo(xButton)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(xButton.snp.bottom).offset(28)
        }
        
        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(buttonStackView)
        }
    }
}

extension StudyActivityHeaderView {
    static func makeHeaderButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        
        return button
    }
}
