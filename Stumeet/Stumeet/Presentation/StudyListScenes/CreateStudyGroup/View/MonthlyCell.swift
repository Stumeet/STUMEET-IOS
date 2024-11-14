//
//  MonthlyCell.swift
//  Stumeet
//
//  Created by 정지훈 on 8/11/24.
//

import UIKit

final class MonthlyCell: BaseCollectionViewCell {
    
    // MARK: - UIComponents
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textAlignment = .center
        label.textColor = StumeetColor.gray400.color
        
        return label
    }()
    
    override func setupStyles() {
        layer.cornerRadius = 8
        backgroundColor = StumeetColor.gray75.color
    }
    
    override func setupAddView() {
        [
            dayLabel
        ]   .forEach(addSubview)
    }
    
    override func setupConstaints() {
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.size = CGSize(width: dayLabel.text == "마지막 날" ? 184 : 40, height: 40)
        return layoutAttributes
    }
    
    func updateCell(day: CalendarDate) {
        dayLabel.text = day.date
        isSelected = day.isSelected
        
        if day.isSelected {
            backgroundColor = StumeetColor.primary700.color
            dayLabel.textColor = .white
        } else {
            backgroundColor = StumeetColor.gray75.color
            dayLabel.textColor = StumeetColor.gray400.color
        }
    }
}
