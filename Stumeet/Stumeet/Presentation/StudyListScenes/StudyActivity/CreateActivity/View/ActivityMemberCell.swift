//
//  ActivityMemberCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/13/24.
//

import UIKit

import SnapKit

class ActivityMemberCell: UITableViewCell {
    
    // TODO: - Dev Merge후 BaseCell로 변경
    // TODO: - UITableView++Extension 으로 이전 주석 확인 후 삭제 필요
    // static let identifier = "ActivityMemberCell"
    
    // MARK: - UIComponents
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkMark")
        imageView.isHidden = true
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium15.font, color: .gray800)
    }()
    
    private let stateLabel: UILabel = {
        let label = PaddingLabel()
        label.setPadding(top: 4, bottom: 4, left: 12, right: 12)
        label.font = StumeetFont.bodyMedium14.font
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpStyle()
        setUpAddView()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpStyle() {
        selectionStyle = .none
    }
    
    func setUpAddView() {
        [
            profileImageView,
            nameLabel,
            checkMarkImageView,
            stateLabel
        ]   .forEach { addSubview($0) }
    }
    
    func setUpConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView)
        }
        
        checkMarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(32)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - Configure
    
    func configureCell(_ item: ActivityMember) {
        if item.isSelected {
            nameLabel.textColor = StumeetColor.primary700.color
            backgroundColor = StumeetColor.primary50.color
            checkMarkImageView.isHidden = false
        } else {
            nameLabel.textColor = StumeetColor.gray800.color
            backgroundColor = .white
            checkMarkImageView.isHidden = true
        }
        nameLabel.text = item.name
    }
    
    func configureDetailMemeberCell(item: DetailActivityMember) {
        nameLabel.text = item.name
        stateLabel.isHidden = false
        
        switch item.state {
        case .perform, .attendance, .okAbsent:
            stateLabel.backgroundColor = StumeetColor.primary50.color
            stateLabel.textColor = StumeetColor.primary700.color
        case .notperform, .absent:
            stateLabel.backgroundColor = StumeetColor.danger50.color
            stateLabel.textColor = StumeetColor.danger500.color
        case .late, .okPerform:
            stateLabel.backgroundColor = StumeetColor.warning50.color
            stateLabel.textColor = StumeetColor.warning500.color
        case .noParticipation, .beforeStart:
            stateLabel.backgroundColor = StumeetColor.gray75.color
            stateLabel.textColor = StumeetColor.gray400.color
        }
        stateLabel.text = item.state.rawValue
    }
    
}
