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
            buttonStackView
        ]   .forEach { addSubview($0) }
    }
    
    override func setupConstaints() {
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(12)
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
