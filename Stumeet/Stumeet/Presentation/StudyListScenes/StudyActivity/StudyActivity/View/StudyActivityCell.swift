//
//  StudyActivityCell.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import Combine
import UIKit

class StudyActivityCell: BaseCollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "StudyActivityCell"
    
    // MARK: - UIComponents
    
    private let tagLabel: UILabel = {
        let label = PaddingLabel()
        label.setPadding(top: 4, bottom: 4, left: 12, right: 12)
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primaryInfo.color
        label.backgroundColor = StumeetColor.primary50.color
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium16.font, color: StumeetColor.gray800)
    }()
    
    private let contentLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium16.font, color: StumeetColor.gray600)
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.captionMedium13.font, color: StumeetColor.gray300)
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "marker")
        
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.captionMedium13.font, color: StumeetColor.gray300)
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: StumeetColor.gray500)
    }()
    
    private let dayLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium14.font, color: StumeetColor.gray300)
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.layer.masksToBounds = false
        view.layer.borderColor = StumeetColor.primary50.color.cgColor
        view.layer.borderWidth = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 13
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = PaddingLabel()
        label.setPadding(top: 4, bottom: 4, left: 12, right: 12)
        label.font = StumeetFont.bodyMedium14.font
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        
        return label
    }()
}

// MARK: ConfigureUI

extension StudyActivityCell {
    
    
    func allAddView() {
        
        [
            profileImageView,
            nameLabel,
            dayLabel
        ]   .forEach { bottomStackView.addArrangedSubview($0) }
        
        [
            tagLabel,
            titleLabel,
            contentLabel,
            timeImageView,
            timeLabel,
            placeImageView,
            placeLabel,
            bottomStackView
        ]   .forEach { containerView.addSubview($0) }
        
        addSubview(containerView)
    }
    
    func setUpAllConstaints() {
        tagLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(contentLabel.snp.bottom).offset(7)
            make.width.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImageView.snp.trailing).offset(4)
            make.height.equalTo(16)
            make.top.equalTo(contentLabel.snp.bottom).offset(7)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.width.height.equalTo(16)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(4)
            make.height.equalTo(16)
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(placeImageView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    func configureAllUI(item: Activity) {
        
        allAddView()
        setUpAllConstaints()
        configureTagText(item: item)
        
        titleLabel.text = item.title
        contentLabel.text = item.content
        nameLabel.text = item.name
        dayLabel.text = item.day?.timeAgoSince()
        
        if let place = item.place {
            placeLabel.text = place
        } else {
            placeImageView.isHidden = true
        }
        
        if placeLabel.isHidden && timeLabel.isHidden {
            bottomStackView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(24)
                make.top.equalTo(contentLabel.snp.bottom).offset(19)
                make.bottom.equalToSuperview().inset(16)
            }
        } else if placeLabel.isHidden {
            bottomStackView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(24)
                make.top.equalTo(timeImageView.snp.bottom).offset(20)
                make.bottom.equalToSuperview().inset(16)
            }
        }
    }
    
    func groupAddView() {
        [
            titleLabel,
            timeImageView,
            timeLabel,
            placeLabel,
            placeImageView,
            statusLabel
        ]   .forEach { addSubview($0) }
    }
    
    func setUpGroupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(statusLabel.snp.leading).offset(-17)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImageView.snp.trailing).offset(2)
            make.centerY.equalTo(timeImageView)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(16)
            make.top.equalTo(timeImageView)
            make.width.height.equalTo(16)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeImageView.snp.trailing).offset(2)
            make.centerY.equalTo(placeImageView)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureGroupUI(item: Activity) {
        groupAddView()
        setUpGroupConstraints()
        updateStatusLabel(status: item.status!)
        configureTimeLabel(text: item.startTiem)
        
        titleLabel.text = item.title
        placeLabel.text = item.place
        
        if timeImageView.isHidden { timeImageView.isHidden = false }
        if placeImageView.isHidden { placeImageView.isHidden = false }
    }
    
    func taskAddView() {
        
        [
            titleLabel,
            timeImageView,
            timeLabel,
            statusLabel
        ]   .forEach { addSubview($0) }
    }
    
    func setUpTaskConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(statusLabel.snp.leading).offset(-17)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImageView.snp.trailing).offset(2)
            make.centerY.equalTo(timeImageView)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureTaskUI(item: Activity) {
        taskAddView()
        setUpTaskConstraints()
        updateStatusLabel(status: item.status!)
        configureTimeLabel(text: item.endTime)
        
        titleLabel.text = item.title
        
        if timeImageView.isHidden { timeImageView.isHidden = false }
    
    }
    
    func updateStatusLabel(status: ActivityState) {
        switch status {
        case .perform, .attendance, .okAbsent:
            statusLabel.backgroundColor = StumeetColor.primary50.color
            statusLabel.textColor = StumeetColor.primary700.color
        case .notperform, .absent:
            statusLabel.backgroundColor = StumeetColor.danger50.color
            statusLabel.textColor = StumeetColor.danger500.color
        case .late, .okPerform:
            statusLabel.backgroundColor = StumeetColor.warning50.color
            statusLabel.textColor = StumeetColor.warning500.color
        case .noParticipation, .beforeStart:
            statusLabel.backgroundColor = StumeetColor.gray75.color
            statusLabel.textColor = StumeetColor.gray400.color
        }
        statusLabel.text = status.rawValue
    }
    
    func configureTagText(item: Activity) {
        var time: String?
        switch item.tag {
        case .meeting:
            time = item.startTiem
        case .homework:
            time = item.endTime?.appending(" 까지")
        default: break
        }
        tagLabel.text = item.tag?.title
        configureTimeLabel(text: time)
    }
    
    func configureTimeLabel(text: String?) {
        guard let timeText = text
        else {
            timeImageView.isHidden = true
            return
        }
        timeLabel.text = timeText.formattedDateHHmm()
    }
}
