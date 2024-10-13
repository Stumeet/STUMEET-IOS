//
//  StudyMemberMeetingStateListTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import UIKit
import SnapKit

class StudyMemberMeetingStateListTableViewCell: BaseTableViewCell {
    
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
    
    private lazy var attendanceStateButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = StudyMemberMeetingStateListItem
            .AttendanceState
            .present
            .secondaryColor
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.attributedTitle = AttributedString(
            StudyMemberMeetingStateListItem.AttendanceState.present.title,
            attributes: container
        )
        configuration.baseBackgroundColor = StudyMemberMeetingStateListItem
            .AttendanceState
            .present
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
        label.text = "홍길동"
        return label
    }()
    
    private let stateListHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var stateButtonsDict: [StudyMemberMeetingStateListItem.AttendanceState: UIButton] = [:]
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
            attendanceStateButton
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
            $0.size.equalTo(profileImageSize).priority(.medium)
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
        
        StudyMemberMeetingStateListItem.AttendanceState.allCases.forEach { state in
            let button = createStateButton(for: state)
            stateButtonsDict[state] = button
            stateListHStackView.addArrangedSubview(button)
        }
    }
    
    private func createStateButton(for state: StudyMemberMeetingStateListItem.AttendanceState) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = StumeetColor.gray300.color
        configuration.attributedTitle = AttributedString(state.title, attributes: container)
        configuration.baseBackgroundColor = StumeetColor.gray75.color
        configuration.contentInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configuration?.background.cornerRadius = button
            .systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            ).height / 2
        button.addTarget(self, action: #selector(stateButtonTapped), for: .touchUpInside)
        
        button.tag = state.rawValue
        
        return button
    }
    
    private func updateStateButton(for selectedState: StudyMemberMeetingStateListItem.AttendanceState) {
        for (state, button) in stateButtonsDict {
            var container = AttributeContainer()
            container.font = StumeetFont.bodyMedium14.font
            
            if state == selectedState {
                container.foregroundColor = selectedState.secondaryColor
                
                button.configuration?.attributedTitle = AttributedString(selectedState.title, attributes: container)
                button.configuration?.baseBackgroundColor = selectedState.primaryColor
            } else {
                container.foregroundColor = StumeetColor.gray300.color
                
                button.configuration?.attributedTitle = AttributedString(state.title, attributes: container)
                button.configuration?.baseBackgroundColor = StumeetColor.gray75.color
            }
        }
    }
    
    @objc func toggleStateButtonsVisibility(_ sender: UIButton) {
        guard var taskStateitem else { return }
        
        taskStateitem.isStateHidden.toggle()
        delegate?.didTapTaskState(taskStateitem, cell: self)
    }
    
    @objc func stateButtonTapped(_ sender: UIButton) {
        guard var taskStateitem,
              let selectedStatus = StudyMemberMeetingStateListItem.AttendanceState(rawValue: sender.tag)
        else { return }
        
        taskStateitem.isStateHidden = true
        taskStateitem.attendanceState = selectedStatus
        delegate?.didTapTaskState(taskStateitem, cell: self)
    }
    
    func configureCell(_ item: StudyMemberMeetingStateListItem) {
        taskStateitem = item
        stateListHStackView.isHidden = item.isStateHidden
        
        updateStateButton(for: item.attendanceState)
        
        var container = AttributeContainer()
        container.font = StumeetFont.bodyMedium14.font
        
        if item.isStateHidden {
            container.foregroundColor = taskStateitem?.attendanceState.primaryColor
            
            attendanceStateButton.configuration?.attributedTitle = AttributedString(taskStateitem?.attendanceState.title ?? "", attributes: container)
            attendanceStateButton.configuration?.baseBackgroundColor = taskStateitem?.attendanceState.secondaryColor
            attendanceStateButton.configuration?.image = nil
        } else {
            container.foregroundColor = taskStateitem?.attendanceState.secondaryColor
            
            attendanceStateButton.configuration?.attributedTitle = AttributedString(taskStateitem?.attendanceState.title ?? "", attributes: container)
            attendanceStateButton.configuration?.baseBackgroundColor = taskStateitem?.attendanceState.primaryColor
            attendanceStateButton.configuration?.image = UIImage(
                resource: .StudyMember.iconWhiteArrowDown
            )
            .withTintColor(
                taskStateitem?.attendanceState.secondaryColor ?? .white,
                renderingMode: .alwaysOriginal
            )
        }
    }
}

protocol StudyMemberMeetingStateListTableViewCellDelegate: AnyObject {
    func didTapTaskState(_ item: StudyMemberMeetingStateListItem, cell: StudyMemberMeetingStateListTableViewCell)
}
