//
//  UILabel++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

extension UILabel {
    
    
    /// LabelProperty를 설정하는 함수입니다.
    /// - Parameters:
    ///   - text: String
    ///   - font: UIFont
    ///   - color: StumeetColor
    func setLabelProperty(text: String?, font: UIFont, color: StumeetColor?) -> UILabel {
        if let text = text {
            self.text = text
        }
        self.font = font
        
        if let color = color?.color {
            self.textColor = color
        }
        
        return self
    }
}
