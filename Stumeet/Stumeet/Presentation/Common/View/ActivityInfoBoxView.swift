//
//  ActivityInfoBoxView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/25.
//

import UIKit
import SnapKit

class ActivityInfoBoxView: UIView {
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 14
        return stackView
    }()
    
    private let typeView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        label.text = " "
        return label
    }()
    
    private let innerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    
    private let bodyContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    
    private let mainContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray800.color
        return label
    }()
    
    private let mainSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.gray600.color
        return label
    }()
    
    
    private let subContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private let dateContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .iconClock)
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.gray300.color
        return label
    }()
    
    private let locationContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .iconMapPin)
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.gray300.color
        return label
    }()
    
    private let profileInfoContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let profileInfoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .iconClock)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let profileInfoNameLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.gray500.color
        return label
    }()
    
    private let profileInfoDateLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.gray300.color
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
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
        backgroundColor = StumeetColor.gray50.color
        layer.borderWidth = 1
        layer.borderColor = StumeetColor.primary50.color.cgColor
        layer.cornerRadius = 16
        setShadow()
        
        typeView.setRoundCorner()
        profileInfoImageView.setRoundCorner()
    }
    
    private func setupAddView() {
        addSubview(rootVStackView)
        
        [
            typeView,
            innerVStackView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        typeView.addSubview(typeLabel)
        
        [
            bodyContainerVStackView,
            profileInfoContentHStackView
        ].forEach { innerVStackView.addArrangedSubview($0) }
        
        [
            mainContentVStackView,
            subContentVStackView
        ].forEach { bodyContainerVStackView.addArrangedSubview($0) }
        
        [
            profileInfoImageView,
            profileInfoNameLabel,
            profileInfoDateLabel
        ].forEach { profileInfoContentHStackView.addArrangedSubview($0) }
        
        [
            mainTitleLabel,
            mainSubtitleLabel
        ].forEach { mainContentVStackView.addArrangedSubview($0) }
        
        [
            dateContentHStackView,
            locationContentHStackView
        ].forEach { subContentVStackView.addArrangedSubview($0) }
        
        [
            dateImageView,
            dateLabel
        ].forEach { dateContentHStackView.addArrangedSubview($0) }
        
        [
            locationImageView,
            locationLabel
        ].forEach { locationContentHStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        typeLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        profileInfoImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }

    // MARK: - Function
    // TODO: API 연동 시 수정
    func configureView(isMain: Bool = true) {
        subContentVStackView.isHidden = isMain
        
        typeLabel.text = "모임"
        mainTitleLabel.text = "캠스터디"
        mainSubtitleLabel.text = "이번주 캠 스터디 진행합니다. 참여하시는 분들은 디스코"
        dateLabel.text = "2024.02.00 00:00"
        locationLabel.text = "서울여자대학교"
        profileInfoImageView.image = UIImage(resource: .testHeaderImg)
        profileInfoNameLabel.text = "김철수"
        profileInfoDateLabel.text = "2일 전"
    }
}
