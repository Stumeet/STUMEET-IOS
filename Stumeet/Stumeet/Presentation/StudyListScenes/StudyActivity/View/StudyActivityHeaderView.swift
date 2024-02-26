//
//  StudyActivityHeaderView.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

class StudyActivityHeaderView: BaseCollectionReusableView {
    
    // MARK: - Identifier
    
    static let identifier = "StudyActivityHeaderView"
    
    // MARK: - UIComponents
    
    let allButton: UIButton = {
        let button = makeHeaderButton(title: "전체")
        button.isSelected = true
        
        return button
    }()
    
    let groupButton: UIButton = {
        makeHeaderButton(title: "모임")
    }()
    
    let taskButton: UIButton = {
        makeHeaderButton(title: "과제")
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
            buttonStackView,
            sortButton
        ]   .forEach { addSubview($0) }
    }
    
    override func setupConstaints() {
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(21)
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
