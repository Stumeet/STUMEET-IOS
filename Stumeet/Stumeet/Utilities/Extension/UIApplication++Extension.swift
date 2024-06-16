//
//  UIApplication++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/06/17.
//

import UIKit

extension UIApplication {
    
    /// 최상단 뷰 찾기
    /// - Parameter base: 탐색 뷰
    /// - Returns: 최상단 뷰
    static func topViewController(base: UIViewController? = nil) -> UIViewController? {
        guard let currentWindowScene = UIApplication
            .shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else {
            return nil
        }

        let baseViewController = base ?? currentWindowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        
        if let nav = baseViewController as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = baseViewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        } else if let presented = baseViewController?.presentedViewController {
            return topViewController(base: presented)
        }
        return baseViewController
    }
}
