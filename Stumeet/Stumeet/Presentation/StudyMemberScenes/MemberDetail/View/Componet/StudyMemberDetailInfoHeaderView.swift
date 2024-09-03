//
//  StudyMemberDetailInfoHeaderView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/02.
//

import UIKit
import SnapKit

class StudyMemberDetailInfoHeaderView: UIView {
    
    // MARK: - UIComponents
    private let contentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .StudyGroupMain.testHeaderImg)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let subcontentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
        return stackView
    }()
    
    private let textHStackContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let textHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.subTitleSemiBold.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.text = "홍길동"
        return label
    }()
    
    private lazy var regionAndFieldLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.gray400.color
        label.numberOfLines = 1
        label.text = "서울 · IT"
        return label
    }()
    
    private let complimentButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodysemibold.font
        container.foregroundColor = StumeetColor.primary700.color
        configuration.image = UIImage(resource: .StudyMember.iconCompliment)
        configuration.imagePadding = 8
        configuration.background.cornerRadius = 24
        configuration.attributedTitle = AttributedString("스터디원 칭찬하기", attributes: container)
        configuration.baseBackgroundColor = StumeetColor.primary50.color
        configuration.contentInsets = .init(top: 8, leading: 15, bottom: 8, trailing: 15)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    
    private let achievementContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private let achievementTitleContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var achievementTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodysemibold.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.text = "스터디 성취도"
        return label
    }()
    
    private let achievementProgressHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var achievementProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = StumeetColor.primary700.color
        progressView.trackTintColor = StumeetColor.gray75.color
        progressView.layer.cornerRadius = progressViewheightSize / 2
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = progressViewheightSize / 2
        progressView.subviews[1].clipsToBounds = true
        progressView.progress = 0.4
        return progressView
    }()
    
    private lazy var achievementProgressLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodysemibold.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 1
        label.text = "50%"
        return label
    }()
    
    // MARK: - Properties
    private let profileImageSize: CGFloat = 88
    private let progressViewheightSize: CGFloat = 11
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = .white
    }
    
    private func setupAddView() {
        addSubview(contentHStackView)
        addSubview(achievementContentVStackView)
        
        [
            profileImageView,
            subcontentVStackView
        ].forEach { contentHStackView.addArrangedSubview($0) }
        
        
        [
            textHStackContainerView,
            complimentButton
        ].forEach { subcontentVStackView.addArrangedSubview($0) }
        
        textHStackContainerView.addSubview(textHStackView)
        
        [
            nameLabel,
            regionAndFieldLabel
        ].forEach { textHStackView.addArrangedSubview($0) }
        
        
        [
            achievementTitleContainerView,
            achievementProgressHStackView
        ].forEach { achievementContentVStackView.addArrangedSubview($0) }
        
        achievementTitleContainerView.addSubview(achievementTitleLabel)
        
        [
            achievementProgressView,
            achievementProgressLabel
        ].forEach { achievementProgressHStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        contentHStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        achievementContentVStackView.snp.makeConstraints {
            $0.top.equalTo(contentHStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        achievementTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        achievementProgressView.snp.makeConstraints {
            $0.height.equalTo(progressViewheightSize)
            $0.width.equalTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageSize)
        }
        
        textHStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }
}
