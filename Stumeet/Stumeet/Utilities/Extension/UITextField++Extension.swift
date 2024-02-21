//
//  UITextField++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

extension UITextField {
    
    /// textField에 왼쪽 padding을 넣어줍니다.
    /// - Parameter width: CGFloat
    func addLeftPadding(_ width: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0))
        self.leftViewMode = .always
    }
}
