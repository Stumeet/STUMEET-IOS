//
//  HomeHeaderTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/03.
//

import UIKit
import SnapKit

class HomeHeaderTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary700.color
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let boxBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .Home.boxBackgroundGrape)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let remainingTimeContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 19
        return stackView
    }()
    
    private let remainingTimeContainerView: UIView = {
        let view = UIView(frame: .init(x: .zero, y: .zero, width: .zero, height: 40))
        view.backgroundColor = StumeetColor.gray50.color
        view.setRoundCorner()
        return view
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let descriptionVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.gray50.color
        label.text = "곧 일정이 시작돼요!"
        return label
    }()
    
    private let activityNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.titleBold.font
        label.textColor = StumeetColor.gray50.color
        return label
    }()
    
    private let studyGroupNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.gray50.color
        return label
    }()
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setupAddView() {
        contentView.addSubview(boxView)
        
        boxView.addSubview(boxBackgroundImageView)
        boxView.addSubview(remainingTimeContentVStackView)
        
        [
            descriptionVStackView,
            remainingTimeContainerView
        ].forEach { remainingTimeContentVStackView.addArrangedSubview($0) }
        
        [
            descriptionLabel,
            activityNameLabel,
            studyGroupNameLabel
        ].forEach { descriptionVStackView.addArrangedSubview($0) }

        remainingTimeContainerView.addSubview(remainingTimeLabel)
    }
    
    override func setupConstaints() {
        boxView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        boxBackgroundImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-1)
        }
        
        remainingTimeContentVStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        remainingTimeContainerView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        remainingTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Function
    func configureCell(data: HomeHeaderActivityItem) {
        activityNameLabel.text = data.displayActivityTitle
        studyGroupNameLabel.text = data.displayStudyName
        remainingTimeLabel.text = data.displayRemainingTime
    }
}
