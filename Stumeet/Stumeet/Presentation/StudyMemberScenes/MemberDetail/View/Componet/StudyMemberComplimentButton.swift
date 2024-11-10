//
//  StudyMemberComplimentButton.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/11.
//

import UIKit
import SnapKit

class StudyMemberComplimentButton: UIButton {
    
    // MARK: - UIComponents
    private let rootHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .checkMark)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    // MARK: - Properties
    private var title: String
    
    var isSelectedState: Bool = false {
        didSet {
            updateButtonStyle()
        }
    }
    
    // MARK: - Init
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        label.text = title
        
        layer.borderWidth = 2
        layer.borderColor = StumeetColor.primary700.color.cgColor
        backgroundColor = StumeetColor.gray50.color
        self.setRoundCorner()
    }
    
    private func setupAddView() {
        addSubview(rootHStackView)
        
        [
            label,
            checkImageView
        ].forEach { rootHStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        rootHStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        checkImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    // MARK: - Function
    private func updateButtonStyle() {
        label.textColor = isSelectedState ? StumeetColor.primary700.color : StumeetColor.gray400.color
        checkImageView.isHidden = !isSelectedState
        layer.borderColor = isSelectedState ? StumeetColor.primary700.color.cgColor : StumeetColor.gray75.color.cgColor
    }
}
