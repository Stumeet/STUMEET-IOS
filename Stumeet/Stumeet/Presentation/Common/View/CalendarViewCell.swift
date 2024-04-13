//
//  CalendarCell.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import UIKit

final class CalendarCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "CalendarCell"
    
    // MARK: - UIComponents
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textAlignment = .center
        
        return label
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
    
    func setupAddView() {
        [
            dayLabel
        ]   .forEach { addSubview($0) }
    }
    
    func setupConstaints() {
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    // MARK: - Configure
    
    func configureWeekCell(text: String) {
        let font = StumeetFont.captionMedium12.font
        if font != lastFont {
            dayLabel.font = font
            dayLabel.textColor = StumeetColor.gray400.color
            lastFont = font
        }
        dayLabel.text = text
    }
    
    func configureDayCell(text: String) {
        dayLabel.text = text
        let font = StumeetFont.bodyMedium14.font
        if font != lastFont {
            dayLabel.font = font
            dayLabel.textColor = .black
            lastFont = font
        }
        dayLabel.text = text
    }
    
}
