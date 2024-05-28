//
//  DetailStudyActivityBottomCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

class DetailStudyActivityBottomCell: BaseCollectionViewCell {
    static let identifier = "DetailStudyActivityBottomCell"
    
    // MARK: - UIComponents
    
    private let firstProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let secondProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let thirdProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let fourthProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let memberCountButton: UIButton = {
        let button = UIButton()
        button.setTitle("+2", for: .normal)
        button.titleLabel?.font = StumeetFont.bodyMedium14.font
        button.setTitleColor(StumeetColor.gray500.color, for: .normal)
        
        return button
    }()
    
    private var separationLine: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray75.color
        
        return view
    }()
    
    private let startDateTextLabel: UILabel = {
        return UILabel().setLabelProperty(text: "시작 일시", font: StumeetFont.bodyMedium15.font, color: .gray500)
    }()
    
    private let startDateLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: .primary700)
    }()
    
    private let endDateTextLabel: UILabel = {
        return UILabel().setLabelProperty(text: "종료 일시", font: StumeetFont.bodyMedium15.font, color: .gray500)
    }()
    
    private let endDateLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: .primary700)
    }()
    
    private let placeTextLabel: UILabel = {
        return UILabel().setLabelProperty(text: "장소", font: StumeetFont.bodyMedium15.font, color: .gray500)
    }()
    
    private let placeLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: .primary700)
    }()
    
    // MARK: - SetUp
    
    override func setupAddView() {
        
        
        [
            fourthProfileImageView,
            thirdProfileImageView,
            secondProfileImageView,
            firstProfileImageView,
            memberCountButton,
            separationLine,
            startDateTextLabel,
            startDateLabel,
            endDateTextLabel,
            endDateLabel,
            placeTextLabel,
            placeLabel
        ]   .forEach(addSubview)
    }
    
    override func setupConstaints() {
        
        firstProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        secondProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(firstProfileImageView.snp.trailing).offset(-8)
            make.top.equalTo(firstProfileImageView)
            make.width.height.equalTo(24)
        }
        
        thirdProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(secondProfileImageView.snp.trailing).offset(-8)
            make.top.equalTo(firstProfileImageView)
            make.width.height.equalTo(24)
        }
        
        fourthProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(thirdProfileImageView.snp.trailing).offset(-8)
            make.top.equalTo(firstProfileImageView)
            make.width.height.equalTo(24)
        }
        
        memberCountButton.snp.makeConstraints { make in
            make.leading.equalTo(fourthProfileImageView.snp.trailing).offset(4)
            make.centerY.equalTo(firstProfileImageView)
        }
        
        separationLine.snp.makeConstraints { make in
            make.top.equalTo(firstProfileImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        startDateTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(separationLine.snp.bottom).offset(24)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(startDateTextLabel)
        }
        
        endDateTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(startDateTextLabel.snp.bottom).offset(48)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(endDateTextLabel)
        }
        
        placeTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(endDateTextLabel.snp.bottom).offset(48)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(placeTextLabel)
        }
    }
    
    func configureCell(_ item: DetailStudyActivityBottom) {
        startDateLabel.text = item.startDate
        endDateLabel.text = item.endDate
        placeLabel.text = item.place
    }
    
}
