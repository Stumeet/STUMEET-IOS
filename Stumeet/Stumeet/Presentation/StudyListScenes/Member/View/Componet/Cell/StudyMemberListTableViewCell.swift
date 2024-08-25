//
//  StudyMemberListTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/25.
//

import UIKit
import SnapKit
import Kingfisher

class StudyMemberListTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let textHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let iconHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImageSize / 2
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray700.color
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var regionAndFieldLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray300.color
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var adminIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .StudyMember.crown))
        return imageView
    }()

    // MARK: - Properties
    private let profileImageSize: CGFloat = 40
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }

    override func setupAddView() {
        contentView.addSubview(rootHStackView)
        
        [
            profileImageView,
            iconHStackView
        ].forEach { rootHStackView.addArrangedSubview($0) }
        
        [
            textHStackView,
            adminIconImageView
        ].forEach { iconHStackView.addArrangedSubview($0) }
        
        [
            nameLabel,
            regionAndFieldLabel
        ].forEach { textHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        rootHStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.lessThanOrEqualToSuperview().inset(32)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageSize)
        }
    }
    
    // MARK: - Function
    // TODO: - API 연동 시 수정
    func configureCell() {
        profileImageView.image = UIImage(resource: .StudyGroupMain.testHeaderImg)
        nameLabel.text = "홍길동"
        regionAndFieldLabel.text = "서울 · IT"
        adminIconImageView.isHidden = false
    }
}
