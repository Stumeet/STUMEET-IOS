//
//  UIVIew++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/13/24.
//

import UIKit

extension UIView {
    
    /// 회원가입 네비게이션 바 아래 progressBar 만드는 함수
    /// - Parameter percent: Float
    func makeProgressBar(percent: CGFloat) -> UIView {
        let view = UIView()
        let layer = CALayer()
        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: UIScreen.main.bounds.width * percent, height: 4)
        
        layer.backgroundColor = StumeetColor.success.color.cgColor
        layer.frame = CGRect(origin: origin, size: size)
        
        view.layer.addSublayer(layer)
        view.backgroundColor = StumeetColor.gray75.color
        
        return view
    }
}
