//
//  UIButton++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

extension UIButton {
    
    
    /// RegisterScene에 들어가는 공통된 하단 버튼을 만드는 함수입니다.
    /// - Parameter text: "button title"
    func makeRegisterBottomButton(text: String, color: UIColor) -> UIButton {
        self.setTitle(text, for: .normal)
        self.setTitleColor(StumeetColor.gray50.color, for: .normal)
        self.backgroundColor = color
        self.layer.cornerRadius = 16
        
        return self
    }
}
