//
//  MyEvaluationTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import UIKit
import SnapKit

class MyEvaluationTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private lazy var evaluationProgressView = ProgressBarView()
    
    private let rootHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        return label
    }()
    
    private var countLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Properties
    private var bottomConst: Constraint?
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }

    override func setupAddView() {
        contentView.addSubview(evaluationProgressView)
        contentView.addSubview(rootHStackView)
        
        [
            titleLabel,
            countLabel
        ].forEach { rootHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        evaluationProgressView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(49)
            $0.horizontalEdges.equalToSuperview().inset(24)
            bottomConst = $0.bottom.equalToSuperview().inset(12).constraint
        }
        
        rootHStackView.snp.makeConstraints {
            $0.leading.equalTo(evaluationProgressView.snp.leading).inset(16)
            $0.trailing.equalTo(evaluationProgressView.snp.trailing).inset(28)
            $0.centerY.equalTo(evaluationProgressView)
        }
    }
    
    // MARK: - Function
    func configureCell(_ item: MyEvaluationItem) {
        titleLabel.text = item.title
        countLabel.text = "\(item.count)"
        evaluationProgressView.setProgress(item.evaluationProgress)
        bottomConst?.update(inset: item.isLastItem ? 0 : 12)
    }
}

