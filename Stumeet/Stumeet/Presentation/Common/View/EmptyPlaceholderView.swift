//
//  EmptyPlaceholderView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/05.
//

import UIKit
import SnapKit

class EmptyPlaceholderView: UIView {
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let mainImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .Common.tablerBook)
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray300.color
        return label
    }()
    
    // MARK: - Init
    init(text: String) {
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
        setupStyles()
        configure(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = StumeetColor.gray50.color
    }
    
    private func setupAddView() {
        addSubview(rootVStackView)
        
        [
            mainImageView,
            titleLabel
        ].forEach { rootVStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configure(with title: String) {
        titleLabel.setTextWithLineHeight(text: title, lineHeight: 23)
    }
}
