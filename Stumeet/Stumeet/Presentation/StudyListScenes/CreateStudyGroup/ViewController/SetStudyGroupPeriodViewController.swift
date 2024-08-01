//
//  SetStudyGroupPeriodViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 7/31/24.
//

import UIKit

class SetStudyGroupPeriodViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0
        
        return button
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private let dragIndicatorContainerView = UIView()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        view.layer.cornerRadius = 7
        return view
        
    }()
    
    private let startDateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.imagePadding = 4
        config.image = UIImage(resource: .calendar)
        var titleAttributes = AttributedString()
        titleAttributes.font = StumeetFont.bodyMedium14.font
        titleAttributes.foregroundColor = StumeetColor.primary700.color
        config.attributedTitle = titleAttributes
        
        button.configuration = config
        
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let ingLabel = UILabel().setLabelProperty(text: "~", font: StumeetFont.bodyMedium15.font, color: .gray800)
    
    private let endDateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(resource: .calendar).withTintColor(StumeetColor.gray400.color)
        config.imagePadding = 4
        
        var titleAttributes = AttributedString("날짜 선택...")
        titleAttributes.font = StumeetFont.bodyMedium14.font
        titleAttributes.foregroundColor = StumeetColor.gray400.color
        config.attributedTitle = titleAttributes
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.gray75.color.cgColor
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private let calendarView = CalendarView()
    
    private let completeButton = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    // MARK: - SetUp
    
    override func setupAddView() {
        [
            dragIndicatorView
        ]   .forEach { dragIndicatorContainerView.addSubview($0) }
        
        
        [
            dragIndicatorContainerView,
            startDateButton,
            ingLabel,
            endDateButton,
            calendarView,
            completeButton
        ]   .forEach { bottomSheetView.addSubview($0) }
        
        [
            backgroundButton,
            bottomSheetView
        ]   .forEach { view.addSubview($0) }
        
    }
    
    override func setupConstaints() {
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        dragIndicatorContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(30)
            make.width.equalTo(72)
        }
        
        dragIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(8)
        }
        
        startDateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(35)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(52)
        }
        
        ingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(startDateButton)
            make.leading.equalTo(startDateButton.snp.trailing).offset(17)
            make.width.equalTo(12)
        }
        
        endDateButton.snp.makeConstraints { make in
            make.leading.equalTo(ingLabel.snp.trailing).offset(17)
            make.trailing.equalToSuperview().inset(35)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(52)
            make.width.equalTo(startDateButton.snp.width)
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(startDateButton.snp.bottom).offset(25)
            make.height.equalTo(261)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(startDateButton.snp.bottom).offset(318)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        
    }
}

// MARK: - UIUpdate

extension SetStudyGroupPeriodViewController {
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(536)
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
}
