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
        self.titleLabel?.font = StumeetFont.titleSemibold.font
        self.backgroundColor = color
        self.layer.cornerRadius = 16
        
        return self
    }
    
    /// UIButton에 디자인 시스템에서 정의한 스타일 적용
    /// - Parameter style: 적용할 스타일을 정의한 ButtonStyle 열거형 값
    func applyStyle(_ style: ButtonStyle) {
        style.apply(to: self)
    }
}

enum ButtonStyle {
    case abled
    case disabled
    case pressed
    
    func apply(to button: UIButton) {
        switch self {
        case .abled:
            button.backgroundColor = StumeetColor.primary700.color
            button.setTitleColor(StumeetColor.gray50.color, for: .normal)
        case .disabled:
            button.backgroundColor = .lightGray
            button.setTitleColor(.black, for: .normal)
        case .pressed:
            button.backgroundColor = .systemRed
            button.setTitleColor(.white, for: .normal)
        }
        
        button.layer.cornerRadius = 16
        button.titleLabel?.font = StumeetFont.titleSemibold.font
    }
}
