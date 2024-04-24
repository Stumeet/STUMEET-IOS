//
//  StudyGroupListTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/15.
//

import UIKit
import SnapKit

protocol StudyGroupListTableViewCellDelegate: AnyObject {
    func didTapMoreButton(button: UIView)
}

class StudyGroupListTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootHStackView = UIStackView()
    
    private let thumbnailImageView = UIImageView()
    
    private let mainContentView = UIView()
    private let mainDetailsVStackView = UIStackView()
    
    private let mainDetailsInfoHStackView = UIStackView()
    private let mainDetailsInfoTitleLabel = UILabel()
    private let mainDetailsInfoSubTitleLabel = UILabel()
    
    private let mainDetailsPeriodLabel = UILabel()
    
    private let moreButtonContainer = UIView()
    private let moreButtonView = UIView()
    private let moreButtonImageView = UIImageView()
    
    // MARK: - Properties
    weak var delegate: StudyGroupListTableViewCellDelegate?
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
        
        rootHStackView.axis = .horizontal
        rootHStackView.spacing = 16
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 16
        thumbnailImageView.backgroundColor = .gray
        
        mainDetailsVStackView.axis = .vertical
        mainDetailsVStackView.spacing = 9
        
        mainDetailsInfoHStackView.axis = .horizontal
        mainDetailsInfoHStackView.spacing = 8
        
        mainDetailsInfoTitleLabel.textColor = StumeetColor.gray800.color
        mainDetailsInfoTitleLabel.font = StumeetFont.bodyMedium16.font
        mainDetailsInfoTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        mainDetailsInfoSubTitleLabel.textColor = StumeetColor.primary700.color
        mainDetailsInfoSubTitleLabel.font = StumeetFont.bodyMedium16.font
        mainDetailsInfoSubTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        mainDetailsPeriodLabel.textColor = StumeetColor.gray400.color
        mainDetailsPeriodLabel.font = StumeetFont.bodyMedium14.font
        
        moreButtonImageView.image = UIImage(named: "tabler_dots-vertical")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moreButtonAction))
        moreButtonView.addGestureRecognizer(tapGesture)
    }

    override func setupAddView() {
        contentView.addSubview(rootHStackView)
        
        [
            thumbnailImageView,
            mainContentView,
            moreButtonContainer
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
        
        moreButtonContainer.addSubview(moreButtonView)
        moreButtonView.addSubview(moreButtonImageView)
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
            $0.width.height.equalTo(64)
        }
        
        moreButtonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        moreButtonImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(16)
        }
    }
    
    // MARK: - Function
    @objc func moreButtonAction(_ sender: UITapGestureRecognizer) {
        guard let button = sender.view else { return }
        delegate?.didTapMoreButton(button: button)
    }
    
    func configureCell() {
        mainDetailsInfoTitleLabel.text = "자바를 자바"
        mainDetailsInfoSubTitleLabel.text = "7"
        mainDetailsPeriodLabel.text = "2023.10.20 ~ 2024.01.10"
    }
}
