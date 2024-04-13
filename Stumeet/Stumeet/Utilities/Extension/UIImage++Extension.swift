//
//  UIImage++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import UIKit

extension UIImage {
    
    /// Image를 원하는 크기로 재설정
    /// - Parameter size: CGSize
    /// - Returns: UIImage
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
