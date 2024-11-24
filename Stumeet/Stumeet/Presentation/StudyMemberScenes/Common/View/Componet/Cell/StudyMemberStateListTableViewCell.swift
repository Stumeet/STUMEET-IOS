//
//  StudyMemberStateListTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import UIKit
import SnapKit
import Kingfisher

class StudyMemberStateListTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 9
        stackView.axis = .vertical
        return stackView
    }()
    
    private let mainHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let profileHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImageSize / 2
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var currentStateButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = ActivityState
            .attendance
            .secondaryColor
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.attributedTitle = AttributedString(
            ActivityState
                .attendance.rawValue,
            attributes: container
        )
        configuration.baseBackgroundColor = ActivityState
            .attendance
            .secondaryColor
        configuration.contentInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configuration?.background.cornerRadius = button
            .systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            ).height / 2
        button.addTarget(self, action: #selector(toggleStateButtonsVisibility), for: .touchUpInside)
        
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray700.color
        label.numberOfLines = 1
        return label
    }()
    
    private let stateListHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var stateButtonsDict: [ActivityState: UIButton] = [:]
    private let spacerView = UIView()
    
    // MARK: - Properties
    private let profileImageSize: CGFloat = 40
    private var taskStateitem: StudyMemberMeetingStateListItem?
    weak var delegate: StudyMemberMeetingStateListTableViewCellDelegate?
    
    // MARK: - Init
    override func setupAddView() {
        contentView.addSubview(rootVStackView)
        
        [
            mainHStackView,
            stateListHStackView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        [
            profileHStackView,
            currentStateButton
        ].forEach { mainHStackView.addArrangedSubview($0) }
        
        [
            profileImageView,
            nameLabel
        ].forEach { profileHStackView.addArrangedSubview($0) }
        
        setupStateButtons()
    }

    override func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageSize)
        }
    }
    
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }
    
    // MARK: - Function
    private func setupStateButtons() {
        stateButtonsDict = [:]
        stateListHStackView.addArrangedSubview(spacerView)
        
        ActivityState.allCases.forEach { state in
            let button = createStateButton(for: state)
            stateButtonsDict[state] = button
            stateListHStackView.addArrangedSubview(button)
        }
    }
    
    private func createStateButton(for state: ActivityState) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = StumeetColor.gray300.color
        configuration.attributedTitle = AttributedString(state.rawValue, attributes: container)
        configuration.baseBackgroundColor = StumeetColor.gray75.color
        configuration.contentInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)
        configuration.titleLineBreakMode = .byTruncatingTail
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configuration?.background.cornerRadius = button
            .systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            ).height / 2
        button.addTarget(self, action: #selector(stateButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    private func updateStateButton(for selectedState: ActivityState, category: ActivityCategory) {
        for (state, button) in stateButtonsDict {
            var container = AttributeContainer()
            container.font = StumeetFont.bodyMedium14.font
            
            if state == selectedState {
                container.foregroundColor = selectedState.secondaryColor
                
                button.configuration?.attributedTitle = AttributedString(selectedState.rawValue, attributes: container)
                button.configuration?.baseBackgroundColor = selectedState.primaryColor
            } else {
                container.foregroundColor = StumeetColor.gray300.color
                
                button.configuration?.attributedTitle = AttributedString(state.rawValue, attributes: container)
                button.configuration?.baseBackgroundColor = StumeetColor.gray75.color
            }
        }

        stateButtonsDict.values.forEach { $0.isHidden = true}

        let allStates = ActivityState.allCases
        let currentStates = allStates.filter { $0.category == category }

        currentStates.forEach {
            stateButtonsDict[$0]?.isHidden = false
        }
    }
    
    @objc func toggleStateButtonsVisibility(_ sender: UIButton) {
        guard var taskStateitem else { return }
        
        taskStateitem.isStateHidden.toggle()
        delegate?.didTapActivityState(taskStateitem, cell: self, isToggle: true)
    }
    
    @objc func stateButtonTapped(_ sender: UIButton) {
        guard var taskStateitem,
              let selectedStatus = stateButtonsDict.first(where: { $0.value === sender })?.key
        else { return }
        
        taskStateitem.isStateHidden = true
        taskStateitem.activityState = selectedStatus
        delegate?.didTapActivityState(taskStateitem, cell: self, isToggle: false)
    }
    
    func configureCell(_ item: StudyMemberMeetingStateListItem) {
        taskStateitem = item
        stateListHStackView.isHidden = item.isStateHidden
        nameLabel.text = item.name
        
        if let image = item.profileImage {
            let url = URL(string: image)
            profileImageView.kf.setImage(with: url)
        }
        
        updateStateButton(for: item.activityState, category: item.category)
        
        var container = AttributeContainer()
        container.font = StumeetFont.bodyMedium14.font
        
        if item.isStateHidden {
            container.foregroundColor = taskStateitem?.activityState.primaryColor
            
            currentStateButton.configuration?.attributedTitle = AttributedString(taskStateitem?.activityState.rawValue ?? "", attributes: container)
            currentStateButton.configuration?.baseBackgroundColor = taskStateitem?.activityState.secondaryColor
            currentStateButton.configuration?.image = nil
        } else {
            container.foregroundColor = taskStateitem?.activityState.secondaryColor
            
            currentStateButton.configuration?.attributedTitle = AttributedString(taskStateitem?.activityState.rawValue ?? "", attributes: container)
            currentStateButton.configuration?.baseBackgroundColor = taskStateitem?.activityState.primaryColor
            currentStateButton.configuration?.image = UIImage(
                resource: .StudyMember.iconWhiteArrowDown
            )
            .withTintColor(
                taskStateitem?.activityState.secondaryColor ?? .white,
                renderingMode: .alwaysOriginal
            )
        }
    }
}

protocol StudyMemberMeetingStateListTableViewCellDelegate: AnyObject {
    func didTapActivityState(_ item: StudyMemberMeetingStateListItem, cell: StudyMemberStateListTableViewCell, isToggle: Bool)
}
