//
//  StudyMainMenuTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/18.
//

import UIKit
import SnapKit

class StudyMainMenuTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    private let contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium15.font
        label.textColor = StumeetColor.gray800.color
        return label
    }()
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setupAddView() {
        contentView.addSubview(rootVStackView)

        [
            contentContainerView,
            separatorView
        ].forEach { rootVStackView.addArrangedSubview($0) }

        contentContainerView.addSubview(contentHStackView)
        
        [
            symbolImageView,
            titleLabel
        ].forEach { contentHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        contentHStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        symbolImageView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
    }
    
    // MARK: - Function
    func configureCell(_ item: StudyMainMenu) {
        symbolImageView.image = item.symbolImage
        titleLabel.text = item.title
    }
}
