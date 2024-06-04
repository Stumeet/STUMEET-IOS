//
//  UIColor++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/22.
//

import UIKit

extension UIColor {
    struct RGBAColor {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }
    
    /// `percentage` 매개변수를 사용하여 이 색상과 지정된 다른 색상 사이에서 지정된 비율로 계산되 색상 반환 함수
    /// - Parameters:
    ///   - otherColor: 보간 대상이 되는 색상
    ///   - percentage: 혼합에 사용될 `otherColor`의 가중치를 결정하는 비율, 0과 1 사이 값.
    /// - Returns: 보간된 색상을 나타내는 `UIColor`  반환
    func between(_ otherColor: UIColor, percentage: CGFloat) -> UIColor {
        let clampedPercentage = max(min(percentage, 1), 0)
        
        var rgba1 = RGBAColor(red: 0, green: 0, blue: 0, alpha: 0)
        var rgba2 = RGBAColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.getRed(&rgba1.red, green: &rgba1.green, blue: &rgba1.blue, alpha: &rgba1.alpha)
        otherColor.getRed(&rgba2.red, green: &rgba2.green, blue: &rgba2.blue, alpha: &rgba2.alpha)
        
        let mixedRed = rgba1.red + (rgba2.red - rgba1.red) * clampedPercentage
        let mixedGreen = rgba1.green + (rgba2.green - rgba1.green) * clampedPercentage
        let mixedBlue = rgba1.blue + (rgba2.blue - rgba1.blue) * clampedPercentage
        let mixedAlpha = rgba1.alpha + (rgba2.alpha - rgba1.alpha) * clampedPercentage
        
        return UIColor(red: mixedRed, green: mixedGreen, blue: mixedBlue, alpha: mixedAlpha)
    }
    
    
    /// 16진수 문자열로 색상 초기화
    /// - Parameters:
    ///   - hex: 16진수 문자열
    ///   - configAlpha: 투명도
    convenience init(hex: String, configAlpha: CGFloat? = nil) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: configAlpha ?? CGFloat(alpha) / 255)
    }
}
