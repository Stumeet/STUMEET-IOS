//
//  StudyMainTagCollectionViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/26.
//

import UIKit
import SnapKit

// TODO: API 연동 시 수정
enum StudyMainTagSection: Hashable {
    case main
}

struct StudyMainTag: Hashable {
    let id: Int
    let title: String
}

class StudyMainTagCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UIComponents
    private let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()

    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Init
    override func setupAddView() {
        contentView.addSubview(rootView)
        rootView.addSubview(tagLabel)
    }
    
    override func setupConstaints() {
        rootView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Function
    static func fittingSize(availableHeight: CGFloat, config: String) -> CGSize {
        let cell = StudyMainTagCollectionViewCell()
        cell.configureCell(text: config)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .fittingSizeLevel,
                                                        verticalFittingPriority: .required)
    }
    
    func configureCell(text: String) {
        tagLabel.text = text
        rootView.setRoundCorner()
    }
}
