//
//  MyHeaderView.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

protocol MyHeaderViewDelegate: AnyObject {
    func didTapGrapeButton()
}

class MyHeaderView: UIView {
    
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
        imageView.backgroundColor = StumeetColor.gray50.color
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let subcontentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let textHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.subTitleSemiBold.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private var regionAndFieldLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.gray400.color
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var experienceProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = StumeetColor.primary700.color
        progressView.trackTintColor = StumeetColor.gray75.color
        progressView.layer.cornerRadius = progressViewheightSize / 2
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = progressViewheightSize / 2
        progressView.subviews[1].clipsToBounds = true
        progressView.progress = 0
        return progressView
    }()
    
    private let levelContainerHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private var levelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private var levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 1
        return label
    }()
    
    private var currentExperienceLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.gray300.color
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var grapeButtonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = StumeetColor.gray75.color.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(grapeButtonViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private let grapeButtonHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private var grapeButtonGrapeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .My.iconGrape)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private var grapeButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 1
        return label
    }()
    
    private var grapeButtonArrorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .My.iconArrowRight)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    // MARK: - Properties
    private let profileImageSize: CGFloat = 88
    private let levelImageSize: CGFloat = 16
    private let progressViewheightSize: CGFloat = 10
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: MyHeaderViewDelegate?
    
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
        
        [
            profileImageView,
            subcontentVStackView
        ].forEach { contentHStackView.addArrangedSubview($0) }
        
        
        [
            textHStackView,
            experienceProgressView,
            levelContainerHStackView,
            grapeButtonView
        ].forEach { subcontentVStackView.addArrangedSubview($0) }
        
        
        [
            nameLabel,
            regionAndFieldLabel
        ].forEach { textHStackView.addArrangedSubview($0) }
        
        [
            levelImageView,
            levelTitleLabel,
            currentExperienceLabel
        ].forEach { levelContainerHStackView.addArrangedSubview($0) }
        
        grapeButtonView.addSubview(grapeButtonHStackView)
        
        [
            grapeButtonGrapeIconImageView,
            grapeButtonTitleLabel,
            grapeButtonArrorImageView
        ].forEach { grapeButtonHStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        contentHStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        experienceProgressView.snp.makeConstraints {
            $0.height.equalTo(progressViewheightSize)
            $0.width.equalTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageSize)
        }
        
        levelImageView.snp.makeConstraints {
            $0.size.equalTo(levelImageSize)
        }
        
        grapeButtonView.snp.makeConstraints {
            $0.height.equalTo(49)
        }
        
        grapeButtonHStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        grapeButtonGrapeIconImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        grapeButtonArrorImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    @objc private func grapeButtonViewTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapGrapeButton()
    }
    
    func configure(with item: MyHeaderItem) {
        nameLabel.text = item.displayName
        regionAndFieldLabel.text = item.displayRegionAndField
        
        // FIXME: API 연동 시 수정
//        let url = URL(string: item.profileImagePath)
//        profileImageView.kf.setImage(with: url)
        profileImageView.image = UIImage(resource: .My.iconGrape)
        
        levelImageView.image = UIImage(resource: item.level.imageName)
        levelTitleLabel.text = item.level.rawValue + "단계"
        currentExperienceLabel.text = "\(item.currentExperience)/\(item.level.requiredExperience)"
        grapeButtonTitleLabel.text = "\(item.grapeBunchCount)송이 \(item.grapeBerryCount)개"
        experienceProgressView.progress = item.expProgress
    }
}
