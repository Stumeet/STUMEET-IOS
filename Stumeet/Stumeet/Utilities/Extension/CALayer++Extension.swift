//
//  UILayer++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/17/24.
//

import UIKit

extension CALayer {
    
    /// 원하는 방향에 border를 넣어줍니다.
    /// - Parameters:
    ///   - edges: [방향]
    ///   - color: 색
    ///   - width: borderWdith
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                break
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
