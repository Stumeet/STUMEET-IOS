//
//  OnboardingCollectionViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/24.
//

import UIKit
import SnapKit

class OnboardingCollectionViewCell: BaseCollectionViewCell {
    
    private let rootView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabelContainer: UIView = {
        let view =  UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 2
        return label
    }()

    override func setupAddView() {
        contentView.addSubview(rootView)
        titleLabelContainer.addSubview(titleLabel)
        
        [
            imageView,
            titleLabelContainer
        ].forEach { rootView.addArrangedSubview($0)}
    }
    
    override func setupConstaints() {
        rootView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
                
        titleLabelContainer.snp.makeConstraints {
            $0.height.equalTo(105)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func configure(text: String, imageName: ImageResource) {
        titleLabel.setTextWithLineHeight(text: text, lineHeight: 23.9)
        imageView.image = UIImage(resource: imageName)
    }
}
