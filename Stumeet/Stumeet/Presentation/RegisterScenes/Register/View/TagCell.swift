//
//  TagCell.swift
//  Stumeet
//
//  Created by 정지훈 on 2/12/24.
//

import UIKit

class TagCell: BaseCollectionViewCell {
    static let identifier = "TagCell"
    
    // MARK: - UIComponents
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textAlignment = .center
        label.textColor = StumeetColor.gray600.color
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    override func setupStyles() {
        backgroundColor = StumeetColor.primary50.color
        layer.masksToBounds = true
    }
    
    override func setupAddView() {
        addSubview(tagLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    override func setupConstaints() {
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configureTagCell(item: StudyField) {
        backgroundColor = item.isSelected ? StumeetColor.primaryInfo.color : StumeetColor.primary50.color
        tagLabel.textColor = item.isSelected ? .white : StumeetColor.gray800.color
        tagLabel.text = item.name
    }
    
    func configureCreateStudyTagCell(tag: String) {
        tagLabel.text = tag
        tagLabel.textColor = StumeetColor.primary700.color
    }
}
