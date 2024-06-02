//
//  BaseTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/15.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAddView()
        setupConstaints()
        setupStyles()
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
