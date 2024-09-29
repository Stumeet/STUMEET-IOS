//
//  StudyMemberActivityListTableViewCell.swift.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/04.
//

import UIKit
import SnapKit

class StudyMemberActivityListTableViewCell: BaseTableViewCell {
    
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
    
    private let stateContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.text = " "
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
    
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    // MARK: - Init
    

    override func setupAddView() {
        contentView.addSubview(rootSeparatorVStackView)
        
        [
            topSeparatorView,
            rootContainerView,
            bottomSeparatorView
        ].forEach { rootSeparatorVStackView.addArrangedSubview($0) }
        
        rootContainerView.addSubview(rootVStackView)
        
        [
            primaryHStackView,
            secondaryContentHStackView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        
        [
            titleLabel,
            stateContainerView
        ].forEach { primaryHStackView.addArrangedSubview($0) }
        
        stateContainerView.addSubview(stateLabel)
        
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

    override func setupConstaints() {
        rootSeparatorVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topSeparatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        rootVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        bottomSeparatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }

        stateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(4)
        }
        
        dateImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        locationImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
        stateContainerView.layer.cornerRadius = stateContainerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height / 2
    }
    
    // MARK: - Function
    func configureCell(_ item: StudyMemberActivityListItem) {
        titleLabel.text = item.displayTitle
            
        switch item.cellType {
        case .firstCell:
            topSeparatorView.isHidden = false
        case .normal:
            topSeparatorView.isHidden = true
        }
        
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
        
        switch item.screenType {
        case .detail:
            if let state = item.displayState {
                stateLabel.text = state.rawValue
                stateLabel.textColor = state.primaryColor
                stateContainerView.backgroundColor = state.secondaryColor
                stateContainerView.isHidden = false
                rootVStackView.spacing = 4
            } else {
                stateContainerView.isHidden = true
                rootVStackView.spacing = 8
            }
        case .achievement:
            stateContainerView.isHidden = true
        }
    }
}
