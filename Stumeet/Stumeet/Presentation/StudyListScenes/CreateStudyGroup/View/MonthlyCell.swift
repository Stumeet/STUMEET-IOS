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
            make.width.equalTo(40)
        }
    }
    
    func updateCell(day: CalendarDate) {
        dayLabel.text = day.date
        isSelected = day.isSelected
        
        if day.date == "마지막 날" {
            dayLabel.snp.updateConstraints { make in
                make.width.equalTo(184)
            }
        }
    }
}
