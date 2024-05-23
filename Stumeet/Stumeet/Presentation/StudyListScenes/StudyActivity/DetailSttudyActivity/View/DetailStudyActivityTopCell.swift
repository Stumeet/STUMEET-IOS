//
//  DetailStudyActivityTopCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

class DetailStudyActivityTopCell: UICollectionViewCell {
    static let identifier = "DetailStudyActivityTopCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
