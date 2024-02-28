//
//  OnboardingCollectionViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/24.
//

import UIKit

class OnboardingCollectionViewCell: BaseCollectionViewCell {
    
    private let rootView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing =  33
        
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
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 0
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
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.3463)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }

    func configure(text: String, imageName: String) {
        titleLabel.text = text
        imageView.image = UIImage(named: imageName)
    }
}
