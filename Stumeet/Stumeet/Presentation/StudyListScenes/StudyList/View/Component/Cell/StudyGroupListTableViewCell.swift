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
    private let rootHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .gray
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
    
    private let moreButtonContainer = UIView()
    private lazy var moreButtonView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moreButtonAction))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private let moreButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tabler_dots-vertical")
        return imageView
    }()
    
    // MARK: - Properties
    weak var delegate: StudyGroupListTableViewCellDelegate?
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
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
    
    func configureCell(_ item: Any) {
        mainDetailsInfoTitleLabel.text = "자바를 자바"
        mainDetailsInfoSubTitleLabel.text = "7"
        mainDetailsPeriodLabel.text = "2023.10.20 ~ 2024.01.10"
    }
}
