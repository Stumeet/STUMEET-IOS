//
//  DetailStudyActivityPhotoCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import Combine
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
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - SetUp
    
    override func setupAddView() {
        [
            imageView
        ]   .forEach(addSubview)
    }
    
    override func setupConstaints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(0)
        }
    }
    
    override func prepareForReuse() {
        cancellables = Set<AnyCancellable>()
    }
    
    func configureCreateActivityPhotoCell(image: UIImage) {
        if xButton.superview == nil {
            addSubview(xButton)
            xButton.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(12)
            }
        }
        imageView.snp.updateConstraints { make in
            make.size.equalTo(160)
        }
        imageView.image = image
    }
}
