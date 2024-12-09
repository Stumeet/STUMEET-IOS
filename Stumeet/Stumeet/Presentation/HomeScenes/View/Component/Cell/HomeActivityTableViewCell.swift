//
//  HomeActivityTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/04.
//

import UIKit
import SnapKit

class HomeActivityTableViewCell: BaseTableViewCell {

    // MARK: - UIComponents
    private let activityInfoView = ActivityInfoBoxView()
    
    // MARK: - Properties
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setupAddView() {
        contentView.addSubview(activityInfoView)
    }
    
    override func setupConstaints() {
        activityInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Function
    func configureCell(data: HomeActivityItem) {
        activityInfoView.configureView(data: data)
    }
}
