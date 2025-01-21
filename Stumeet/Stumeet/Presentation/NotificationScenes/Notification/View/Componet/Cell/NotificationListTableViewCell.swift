//
//  NotificationListTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import UIKit
import SnapKit
import Kingfisher

class NotificationListTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
        
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = StumeetColor.gray200.color
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingMiddle
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.gray500.color
        return label
    }()

    // MARK: - Properties
    private let profileImageSize: CGFloat = 48
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }

    override func setupAddView() {
        contentView.addSubview(rootHStackView)
        
        [
            thumbnailImageView,
            titleLabel
        ].forEach { rootHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        rootHStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageSize)
        }
    }
    
    // MARK: - Function
    func configureCell(_ item: NotificationListItem) {
        let fullText = item.title + " " + (item.alertTime ?? "")
        let targetText = item.alertTime
        
        if let targetText, let range = fullText.range(of: targetText, options: .backwards) {
            let attributedText = NSMutableAttributedString(string: fullText)
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: StumeetColor.gray300.color, range: nsRange)
            titleLabel.attributedText = attributedText
        } else {
            titleLabel.text = fullText
        }
        
        if let imageUrl = item.thumbnailImageUrl {
            let url = URL(string: imageUrl)
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}
