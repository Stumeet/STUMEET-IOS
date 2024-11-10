//
//  StudyMemberActivityView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import UIKit
import SnapKit

class StudyMemberActivityView: UIView {
    // MARK: - UIComponents
    private let rootSeparatorVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let rootContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let primaryHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = StumeetColor.gray700.color
        label.font = StumeetFont.bodyMedium16.font
        return label
    }()
    
    private let secondaryContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
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
        imageView.image = UIImage(resource: .StudyGroupMain.iconClock)
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium13.font
        label.textColor = StumeetColor.gray300.color
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        imageView.image = UIImage(resource: .StudyGroupMain.iconMapPin)
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium13.font
        label.textColor = StumeetColor.gray300.color
        return label
    }()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    // MARK: - Init
    init(_ item: StudyMemberActivityViewItem) {
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
        configure(item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddView() {
        addSubview(rootSeparatorVStackView)
        
        [
            rootContainerView,
            bottomSeparatorView
        ].forEach { rootSeparatorVStackView.addArrangedSubview($0) }
        
        rootContainerView.addSubview(rootVStackView)
        
        [
            primaryHStackView,
            secondaryContentHStackView
        ].forEach { rootVStackView.addArrangedSubview($0) }
                
        [
            titleLabel
        ].forEach { primaryHStackView.addArrangedSubview($0) }
        
        [
            dateContentHStackView,
            locationContentHStackView
        ].forEach { secondaryContentHStackView.addArrangedSubview($0) }
        
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
        rootSeparatorVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rootVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        bottomSeparatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        dateImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        locationImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    // MARK: - Function
    func configure(_ item: StudyMemberActivityViewItem) {
        titleLabel.text = item.displayTitle
        
        switch item.type {
        case .meeting:
            dateContentHStackView.isHidden = false
            dateLabel.text = item.displayStartTiem
            
            locationContentHStackView.isHidden = false
            locationLabel.text = item.displayLocation
            
        case .homework:
            dateContentHStackView.isHidden = false
            dateLabel.text = item.displayEndTime
            
            locationContentHStackView.isHidden = true
        default:
            locationContentHStackView.isHidden = true
            dateContentHStackView.isHidden = true
        }
    }
}
