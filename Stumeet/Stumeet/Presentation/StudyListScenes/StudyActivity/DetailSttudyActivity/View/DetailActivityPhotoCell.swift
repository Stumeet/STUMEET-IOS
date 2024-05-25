//
//  DetailActivityPhotoCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import UIKit

final class DetailActivityPhotoCell: BaseCollectionViewCell {
    
    static let identifier = "DetailActivityPhotoCell"
    
    // MARK: - UIComponents
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .changeProfileCharacter)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
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
    
}
