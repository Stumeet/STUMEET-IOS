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
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark).withTintColor(StumeetColor.gray50.color), for: .normal)
        
        return button
    }()
    
    // MARK: - SetUp
    
    override func setupAddView() {
        [
            imageView
        ]   .forEach(addSubview)
    }
    
    override func setupConstaints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCreateActivityPhotoCell(image: UIImage) {
        addSubview(xButton)
        xButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        imageView.image = image
    }
}
