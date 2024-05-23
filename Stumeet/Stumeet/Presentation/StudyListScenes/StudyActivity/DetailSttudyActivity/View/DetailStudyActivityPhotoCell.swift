//
//  DetailStudyActivityPhotoCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

class DetailStudyActivityPhotoCell: UICollectionViewCell {
    static let identifer = "DetailStudyActivityPhotoCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
