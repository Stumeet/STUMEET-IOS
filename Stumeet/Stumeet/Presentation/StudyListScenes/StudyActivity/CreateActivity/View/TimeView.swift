//
//  TimeView.swift
//  Stumeet
//
//  Created by 정지훈 on 4/29/24.
//

import UIKit

import SnapKit

class TimeView: UIView {
    // MARK: - UIComponents
    
    private let ampmBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray75.color
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    let amButton: UIButton = {
        let button = UIButton()
        button.setTitle("오전", for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .normal)
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        
        return button
    }()
    
    let pmButton: UIButton = {
        let button = UIButton()
        button.setTitle("오후", for: .normal)
        button.layer.cornerRadius = 16
        button.setTitleColor(StumeetColor.gray400.color, for: .normal)
        button.backgroundColor = StumeetColor.gray75.color
        
        return button
    }()
    
    private let hourLabel: UILabel = {
        return UILabel().setLabelProperty(text: "시", font: StumeetFont.bodyMedium15.font, color: .gray800)
    }()
    
    var hourButtons: [UIButton] = []
    
    lazy var hourStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        // 내부 스택뷰 추가
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.distribution = .fillEqually
        
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 8
        bottomRow.distribution = .fillEqually
        
        for idx in 1...12 {
            let button = UIButton()
            button.setTitle(String(idx), for: .normal)
            button.setTitleColor(StumeetColor.gray400.color, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = StumeetFont.bodyMedium14.font
            button.backgroundColor = StumeetColor.gray75.color
            button.layer.cornerRadius = 8
            if idx <= 6 {
                topRow.addArrangedSubview(button)
            } else {
                bottomRow.addArrangedSubview(button)
            }
            hourButtons.append(button)
        }
        
        stackView.addArrangedSubview(topRow)
        stackView.addArrangedSubview(bottomRow)
        return stackView
    }()
    
    private let minuteLabel: UILabel = {
        return UILabel().setLabelProperty(text: "분", font: StumeetFont.bodyMedium15.font, color: .gray800)
    }()
    
    var minuteButtons: [UIButton] = []
    
    lazy var minuteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        // 내부 스택뷰 추가
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.distribution = .fillEqually
        
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 8
        bottomRow.distribution = .fillEqually
        
        for idx in 0...11 {
            let button = UIButton()
            let title = String(format: "%02d", idx * 5)
            button.setTitle(title, for: .normal)
            button.setTitleColor(StumeetColor.gray400.color, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = StumeetFont.bodyMedium14.font
            button.backgroundColor = StumeetColor.gray75.color
            button.layer.cornerRadius = 8
            if idx < 6 {
                topRow.addArrangedSubview(button)
            } else {
                bottomRow.addArrangedSubview(button)
            }
            minuteButtons.append(button)
        }
        
        stackView.addArrangedSubview(topRow)
        stackView.addArrangedSubview(bottomRow)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddView() {
        [
            ampmBackgroundView,
            pmButton,
            amButton,
            hourLabel,
            hourStackView,
            minuteLabel,
            minuteStackView
        ]   .forEach { addSubview($0) }
        
    }
    func setupConstraints() {
        ampmBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.height.equalTo(35)
        }
        
        amButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.width.equalTo(172)
            make.height.equalTo(35)
        }
        
        pmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.width.equalTo(172)
            make.height.equalTo(35)
        }
        
        hourLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(amButton.snp.bottom).offset(32)
        }
        
        hourStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26)
            make.height.equalTo(88)
            make.width.equalTo(280)
            make.top.equalTo(hourLabel)
        }
        
        minuteLabel.snp.makeConstraints { make in
            make.leading.equalTo(hourLabel.snp.leading)
            make.top.equalTo(hourStackView.snp.bottom).offset(32)
        }
        
        minuteStackView.snp.makeConstraints { make in
            make.trailing.equalTo(hourStackView.snp.trailing)
            make.height.equalTo(88)
            make.width.equalTo(280)
            make.top.equalTo(minuteLabel)
        }
    }
}
