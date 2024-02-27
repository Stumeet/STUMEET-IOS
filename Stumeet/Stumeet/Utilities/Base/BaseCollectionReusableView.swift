//
//  BaseCollectionReusableView.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

import SnapKit
import Combine

class BaseCollectionReusableView: UICollectionReusableView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyles()
        setupAddView()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View와 관련된 Style을 설정합니다.
    func setupStyles() {
        
    }
    
    /// UI 컴포넌트 프로퍼티를 View에 할당합니다.
    func setupAddView() {
        
    }
    /// UI 컴포넌트 제약조건을 설정합니다.
    func setupConstaints() {
        
    }
}
