//
//  DetailStudyActivityBottomCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

class DetailStudyActivityBottomCell: UICollectionViewCell {
    static let identifier = "DetailStudyActivityBottomCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
