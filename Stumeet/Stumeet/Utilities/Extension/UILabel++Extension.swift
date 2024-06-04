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
    
    /// 텍스트의 라인 간격을 설정
    /// - Parameter lineSpacing: 라인 간격의 크기(포인트 단위)
    func setLineSpacing(lineSpacing: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
    
    /// 지정된 문자열의 색상과 폰트 변경
    /// - Parameters:
    ///   - textToStyle: 스타일을 변경할 문자열
    ///   - color: 적용 색상
    ///   - font: 적용 폰트
    func setColorAndFont(to textToStyle: String, withColor color: UIColor, withFont font: UIFont) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: textToStyle)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
            attributedString.addAttribute(.font, value: font, range: range)
        }
        
        self.attributedText = attributedString
    }
}
