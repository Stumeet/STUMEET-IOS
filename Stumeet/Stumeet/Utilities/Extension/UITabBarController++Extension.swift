//
//  UITabBarController++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/22.
//

import UIKit

extension UITabBarController {
    
    /// 탭 바 배경색 설정
    func setupBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
