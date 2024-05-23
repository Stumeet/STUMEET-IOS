//
//  DetailStudyActivityPhotoCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

class DetailStudyActivityPhotoCell: BaseCollectionViewCell {
    static let identifer = "DetailStudyActivityPhotoCell"
    
    // MARK: - UIComponents
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .systemCyan
        
        return imageView
    }()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    // MARK: - SetUp
    
    override func setupAddView() {
        [
            imageView,
            xButton
        ]   .forEach(addSubview)
    }
    
    override func setupConstaints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        xButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
    }
}
