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
    
    static let identifier = "ActivityMemberCell"
    
    // MARK: - UIComponents
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium15.font, color: .gray800)
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
            nameLabel
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
    }
    
    // MARK: - Configure
    
    func configureCell(_ name: String) {
        nameLabel.text = name
    }
    
}
