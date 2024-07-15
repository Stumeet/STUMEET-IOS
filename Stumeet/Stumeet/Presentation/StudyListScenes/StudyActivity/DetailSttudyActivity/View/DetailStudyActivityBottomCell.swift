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
    
    let memberButton = UIButton()
    
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
            memberButton,
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
        
        memberButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(109)
        }
        
        
        separationLine.snp.makeConstraints { make in
            make.top.equalTo(memberButton.snp.bottom).offset(24)
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
    
    func configureCell(_ item: DetailStudyActivity.Bottom?) {
        
        if let startDate = item?.startDate {
            startDateLabel.text = startDate
        } else {
            startDateLabel.isHidden = true
            startDateTextLabel.isHidden = true
        }
        
        if let endDate = item?.endDate {
            endDateLabel.text = endDate
        } else {
            endDateLabel.isHidden = true
            endDateTextLabel.isHidden = true
        }
        
        if let place = item?.place {
            placeLabel.text = place
        } else {
            placeLabel.isHidden = true
            placeTextLabel.isHidden = true
        }
        
        updateMemberButton(with: item?.memberImageURL ?? [])
    }
    
    private func updateMemberButton(with members: [String]) {
        
        let memberStackView = createMemberImageView(members: members)
        memberButton.addSubview(memberStackView)
        
        if members.count > 4 {
            let count = members.count - 4
            let othersMemberCountLabel = UILabel().setLabelProperty(text: "+\(count)", font: StumeetFont.bodyMedium14.font, color: .gray500)
            
            memberButton.addSubview(othersMemberCountLabel)
            
            othersMemberCountLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(24)
                make.centerY.equalToSuperview()
            }
            
            memberStackView.snp.makeConstraints { make in
                make.trailing.equalTo(othersMemberCountLabel.snp.leading).offset(-4)
                make.centerY.equalToSuperview()
            }
        } else {
            memberStackView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(24)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    private func createMemberImageView(members: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = -8
        stackView.alignment = .trailing
        stackView.isUserInteractionEnabled = false
        
        let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green]
        
        for (index, member) in members.enumerated() {
            if index >= 4 { break }
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = colors[index]
            stackView.addArrangedSubview(imageView)
            imageView.layer.zPosition = CGFloat(-index)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(24)
            }
        }
        
        return stackView
    }
    
}
