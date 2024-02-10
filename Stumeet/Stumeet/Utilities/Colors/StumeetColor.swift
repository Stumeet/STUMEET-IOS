//
//  StumeetColor.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import UIKit

enum StumeetColor {
    case gray50
    case gray75
    case gray100
    case gray200
    case gray300
    case gray400
    case gray500
    case gray600
    case gray700
    case gray800
    case gray900
    case danger
    case warning
    case success
    case primaryInfo
}

extension StumeetColor {
    var color: UIColor {
        switch self {
        case .gray50: return #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        case .gray75: return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9529411765, alpha: 1)
        case .gray100: return #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.9058823529, alpha: 1)
        case .gray200: return #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.8078431373, alpha: 1)
        case .gray300: return #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.7137254902, alpha: 1)
        case .gray400: return #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.6156862745, alpha: 1)
        case .gray500: return #colorLiteral(red: 0.4784313725, green: 0.4784313725, blue: 0.5215686275, alpha: 1)
        case .gray600: return #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.4156862745, alpha: 1)
        case .gray700: return #colorLiteral(red: 0.2862745098, green: 0.2862745098, blue: 0.3137254902, alpha: 1)
        case .gray800: return #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.2078431373, alpha: 1)
        case .gray900: return #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.1058823529, alpha: 1)
        case .danger: return #colorLiteral(red: 0.9215686275, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
        case .warning: return #colorLiteral(red: 0.9568627451, green: 0.6941176471, blue: 0.168627451, alpha: 1)
        case .success: return #colorLiteral(red: 0.03921568627, green: 0.7607843137, blue: 0.5843137255, alpha: 1)
        case .primaryInfo: return #colorLiteral(red: 0.01176470588, green: 0.5058823529, blue: 0.4588235294, alpha: 1)
        }
    }
}
