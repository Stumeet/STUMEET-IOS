//
//  StudyMainActivityTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/25.
//

import UIKit
import SnapKit

class StudyMainActivityTableViewCell: BaseTableViewCell {

    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let registeredNoticeContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let registeredNoticeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .StudyGroupMain.iconPinned)
        return imageView
    }()
    
    private let registeredNoticeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.primary700.color
        label.text = "공지로 등록됨"
        return label
    }()
    
    private let activityInfoView = ActivityInfoBoxView()
    
    // MARK: - Properties
    private var constRootTop: Constraint!
    private var constRootBottom: Constraint!
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setupAddView() {
        contentView.addSubview(rootVStackView)
        
        [
            registeredNoticeContentHStackView,
            activityInfoView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        [
            registeredNoticeImageView,
            registeredNoticeTitleLabel
        ].forEach { registeredNoticeContentHStackView.addArrangedSubview($0) }
        
    }
    
    override func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            
            constRootTop = $0.top.equalToSuperview().inset(8).constraint
            constRootBottom = $0.bottom.equalToSuperview().inset(8).constraint
        }
        
        registeredNoticeImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    // MARK: - Function
    func configureCell(data: StudyMainViewActivityItem) {
        switch data.cellType {
        case .notice:
            registeredNoticeContentHStackView.isHidden = false
            constRootTop.update(inset: 8)
            constRootBottom.update(inset: 16)
            backgroundColor = StumeetColor.primary50.color
        case .activityFirstCell:
            backgroundColor = .clear
            registeredNoticeContentHStackView.isHidden = true
            constRootTop.update(inset: 16)
            constRootBottom.update(inset: 8)
        case .normal:
            backgroundColor = .clear
            registeredNoticeContentHStackView.isHidden = true
            constRootTop.update(inset: 8)
            constRootBottom.update(inset: 8)
        }
        
        activityInfoView.configureView(data: data)
    }

}
