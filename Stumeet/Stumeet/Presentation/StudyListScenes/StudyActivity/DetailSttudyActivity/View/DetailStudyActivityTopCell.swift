//
//  DetailStudyActivityTopCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

class DetailStudyActivityTopCell: BaseCollectionViewCell {
    
    static let identifier = "DetailStudyActivityTopCell"
    
    // MARK: - UIComponents
    
    private let dayLeftLabel: UILabel = {
        let label = PaddingLabel()
        label.setPadding(top: 4, bottom: 4, left: 12, right: 12)
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.primary700.color
        label.backgroundColor = StumeetColor.primary50.color
        label.layer.cornerRadius = 13.5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = PaddingLabel()
        label.setPadding(top: 4, bottom: 4, left: 12, right: 12)
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.warning500.color
        label.backgroundColor = StumeetColor.warning50.color
        label.layer.cornerRadius = 13.5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .systemGreen
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: .gray800)
    }()
    
    private let dateLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.captionMedium12.font, color: .gray300)
    }()
    
    private let separationLine: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray100.color
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.subTitleSemiBold.font, color: .gray800)
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: .gray600)
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - SetUp
    
    override func setupAddView() {
        [
            dayLeftLabel,
            statusLabel,
            profileImageView,
            nameLabel,
            dateLabel,
            separationLine,
            titleLabel,
            contentLabel
        ]   .forEach { addSubview($0) }
    }
    
    override func setupConstaints() {
        dayLeftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.height.equalTo(27)
            make.width.equalTo(87)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(dayLeftLabel.snp.trailing).offset(8)
            make.top.equalTo(dayLeftLabel.snp.top)
            make.height.equalTo(27)
            make.width.equalTo(66)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLeftLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        separationLine.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(separationLine.snp.bottom).offset(24)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configureCell(_ item: DetailStudyActivity.Top?) {
        dayLeftLabel.text = item?.dayLeft
        statusLabel.text = item?.status
        nameLabel.text = item?.name
        dateLabel.text = item?.date
        titleLabel.text = item?.title
        contentLabel.text = item?.content
    }
}
