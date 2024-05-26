//
//  UINavigationBar++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/22.
//

import UIKit

extension UINavigationController {
    
    /// 네비게이션 바의 배경색, 백 버튼 색상을 설정
    /// - Parameters:
    ///   - backgroundColor: 네비게이션 바의 배경색, 기본값:  `.white`
    ///   - backButtonColor: 백 버튼의 색상, 기본값: `StumeetColor.gray800.color`
    func setupBarAppearance(backgroundColor: UIColor = .white, backButtonColor: UIColor = StumeetColor.gray800.color) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(UIImage(resource: .iconNaviBack), transitionMaskImage: UIImage(resource: .iconNaviBack))
        
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0.0)
        ]

        appearance.backButtonAppearance = backButtonAppearance
        navigationBar.tintColor = backButtonColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
    
    /// 현재 네비게이션 바의 색상 설정 업데이트
    /// - Parameters:
    ///   - backgroundColor: 업데이트할 네비게이션 바의 배경색, 기본값: `.white`
    ///   - backButtonColor: 업데이트할 백 버튼의 색상,. 기본값은 `StumeetColor.gray800.color`
    func updateBarColor(backgroundColor: UIColor = .white, backButtonColor: UIColor = StumeetColor.gray800.color) {
        let appearance = navigationBar.standardAppearance.copy()
        appearance.backgroundColor = backgroundColor
        navigationBar.tintColor = backButtonColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
