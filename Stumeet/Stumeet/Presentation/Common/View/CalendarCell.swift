//
//  CalendarCell.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import UIKit

final class CalendarCell: BaseCollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "CalendarCell"
    
    // MARK: - UIComponents
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textAlignment = .center
        
        return label
    }()
    
    private let backgroundRoundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
    
        return view
    }()
    
    // MARK: - Properties
    
    private lazy var lastFont: UIFont = dayLabel.font
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAddView()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp

    override func setupAddView() {
        [
            backgroundRoundView,
            dayLabel
        ]   .forEach { addSubview($0) }
    }
    
    override func setupConstaints() {
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        backgroundRoundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
    }
}

// MARK: - ConfigureCell

extension CalendarCell {
    func configureWeekCell(text: String) {
        let font = StumeetFont.captionMedium12.font
        if font != lastFont {
            dayLabel.font = font
            dayLabel.textColor = StumeetColor.gray400.color
            lastFont = font
        }
        dayLabel.text = text
    }
    
    func configureDayCell(item: CalendarDate) {
        if Int(item.date)! <= 0 {
            dayLabel.text = ""
        } else {
            dayLabel.text = item.date
        }
        
        if item.isPast {
            dayLabel.textColor = StumeetColor.gray300.color
            backgroundRoundView.backgroundColor = .white
            isUserInteractionEnabled = false
        } else {
            isUserInteractionEnabled = true
        }
        
        if item.isSelected {
            backgroundRoundView.backgroundColor = StumeetColor.primary700.color
            dayLabel.textColor = .white
        } else if !item.isSelected && !item.isPast {
            backgroundRoundView.backgroundColor = .white
            dayLabel.textColor = .black
        }
        
        let font = StumeetFont.bodyMedium14.font
        if font != lastFont {
            dayLabel.font = font
            dayLabel.textColor = .black
            lastFont = font
        }
    }
}
