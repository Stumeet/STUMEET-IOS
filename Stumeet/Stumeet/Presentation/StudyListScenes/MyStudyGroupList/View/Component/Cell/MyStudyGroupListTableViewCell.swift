//
//  MyStudyGroupListTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/15.
//

import UIKit
import SnapKit
import Kingfisher

class MyStudyGroupListTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private let newBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary700.color
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mainContentView = UIView()
    private let mainDetailsVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        return stackView
    }()
    
    private let mainDetailsInfoHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let mainDetailsInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = StumeetColor.gray800.color
        label.font = StumeetFont.bodyMedium16.font
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    private let mainDetailsInfoSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = StumeetColor.primary700.color
        label.font = StumeetFont.bodyMedium16.font
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let mainDetailsPeriodLabel: UILabel = {
        let label = UILabel()
        label.textColor = StumeetColor.gray400.color
        label.font = StumeetFont.bodyMedium14.font
        return label
    }()
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
        newBadgeView.layer.cornerRadius = newBadgeView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height / 2
    }

    override func setupAddView() {
        contentView.addSubview(rootHStackView)
        contentView.addSubview(newBadgeView)
        
        [
            thumbnailImageView,
            mainContentView
        ].forEach { rootHStackView.addArrangedSubview($0) }
        
        mainContentView.addSubview(mainDetailsVStackView)
        
        [
            mainDetailsInfoHStackView,
            mainDetailsPeriodLabel
        ].forEach { mainDetailsVStackView.addArrangedSubview($0) }
        
        [
            mainDetailsInfoTitleLabel,
            mainDetailsInfoSubTitleLabel
        ].forEach { mainDetailsInfoHStackView.addArrangedSubview($0) }
        
    }
    
    override func setupConstaints() {
        rootHStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
        
        mainDetailsVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(64)
        }
        
        newBadgeView.snp.makeConstraints {
            $0.size.equalTo(8)
            $0.top.leading.equalTo(thumbnailImageView)
        }
    }
    
    // MARK: - Function
    
    func configureCell(_ item: StudyGroup) {
        mainDetailsInfoTitleLabel.text = item.name
        mainDetailsInfoSubTitleLabel.text = String(item.headcount)
        mainDetailsPeriodLabel.text = "\(item.startDate) ~ \(item.endDate)"
        // TODO: API 변경 필요
        newBadgeView.isHidden = false
        
        guard let image = item.image else { return }
        let url = URL(string: image)
        thumbnailImageView.kf.setImage(with: url)
    }
}
