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
    
    /// 그림자 추가
    /// - Parameters:
    ///   - color: 컬러
    ///   - opacity: 선명도
    ///   - radius: 둥글기
    ///   - offset: 위치
    func setShadow(_ color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 10, offset: CGSize = CGSize(width: 0, height: 0)) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
    
    /// 모서리 둥글게 설정
    func setRoundCorner() {
        self.layer.cornerRadius = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height / 2
    }

}
